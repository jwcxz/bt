-- bt - hardware beat tracker
-- pre-amp and adc controller
-- because apparently nobody has ever made one for this board
-- also this adc sucks.  seriously, who the hell came up with this crazy
-- timing scheme?
-- this code is horribly unoptimized; it could use a ton of redesign

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;
use work.dsize_pkg.all;

entity amp_adc is
    port (
        dbg_state : out std_logic_vector(3 downto 0);
        dbg_scount : out std_logic_vector(7 downto 0);

        clk : in  std_logic;
        rst : in  std_logic;

        amp_cfg  : in  std_logic;
        gain     : in  std_logic_vector(7 downto 0);
        amp_done : out std_logic;

        start_conv : in  std_logic;
        adc_done   : out std_logic;
        adc_a      : out std_logic_vector(13 downto 0);
        adc_b      : out std_logic_vector(13 downto 0);

        amp_cs    : out std_logic;
        adc_start : out std_logic;
        spi_sck   : out std_logic;
        spi_mosi  : out std_logic;
        spi_adc   : in  std_logic;
        spi_amp   : in  std_logic
    );
end amp_adc;

architecture amp_adc_arch of amp_adc is
    type state_type is (
        ST_AMP_WAIT,
        ST_AMP_START,
        ST_AMP_START_D,
        ST_AMP_LD_HI,
        ST_AMP_LD_LO,
        ST_AMP_DONE,
        ST_ADC_WAIT,
        ST_ADC_START,
        ST_ADC_START_D,
        ST_ADC_LD_HI,
        ST_ADC_LD_LO,
        ST_ADC_DONE
    );

    signal state_next, state : state_type;

    signal pulse_count : unsigned(3 downto 0);
    signal slow_pulse  : std_logic;

    signal scount : unsigned(5 downto 0);

    signal ingain : std_logic_vector(7 downto 0);
    signal indata : std_logic_vector(33 downto 0);

    signal run_slow : std_logic;

begin
    dbg_state <= x"0" when state = ST_AMP_WAIT else
                 x"1" when state = ST_AMP_START else
                 x"2" when state = ST_AMP_START_D else
                 x"3" when state = ST_AMP_LD_HI else
                 x"4" when state = ST_AMP_LD_LO else
                 x"5" when state = ST_AMP_DONE else
                 x"6" when state = ST_ADC_WAIT else
                 x"7" when state = ST_ADC_START else
                 x"8" when state = ST_ADC_START_D else
                 x"9" when state = ST_ADC_LD_HI else
                 x"A" when state = ST_ADC_LD_LO else
                 x"B" when state = ST_ADC_DONE else
                 x"F";

    dbg_scount <= "00" & std_logic_vector(scount);

    adc_a <= indata(31 downto 18);
    adc_b <= indata(15 downto  2);

    slowclk_gen : process(clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                pulse_count <= (others => '0');
            else
                if pulse_count = 12 then
                    pulse_count <= (others => '0');
                    slow_pulse <= '1';
                else
                    pulse_count <= pulse_count + 1;
                    slow_pulse <= '0';
                end if;
            end if;
        end if;
    end process;

    state_controller_seq  : process(clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                state <= ST_AMP_WAIT;
                
                amp_done <= '0';
                adc_done <= '0';
                amp_cs <= '1';
                adc_start <= '0';
                spi_sck <= '0';

                ingain <= (others => '0');
                indata <= (others => '0');

                run_slow <= '0';
            else
                if (run_slow = '1' and slow_pulse = '1') or (run_slow = '0') then
                    state <= state_next;

                    case state is
                        when ST_AMP_WAIT =>
                            amp_done <= '0';
                            adc_done <= '0';
                            amp_cs <= '1';
                            adc_start <= '0';
                            spi_sck <= '0';

                        when ST_AMP_START => 
                            amp_cs <= '0';
                            scount <= (others => '0');
                            ingain <= gain;
                            run_slow <= '1';

                        --when ST_AMP_START_D => 

                        when ST_AMP_LD_HI => 
                            spi_sck  <= '1';
                            ingain   <= ingain(6 downto 0) & '0';

                        when ST_AMP_LD_LO =>
                            spi_sck <= '0';
                            spi_mosi <= ingain(7);
                            scount   <= scount + 1;

                        when ST_AMP_DONE => 
                            amp_cs   <= '1';
                            amp_done <= '1';
                            run_slow <= '0';

                        --when ST_ADC_WAIT => 
                            
                        when ST_ADC_START => 
                            adc_done  <= '0';
                            adc_start <= '1';
                            scount <= (others => '0');
                        
                        when ST_ADC_START_D => 
                            adc_start <= '0';

                        when ST_ADC_LD_HI => 
                            spi_sck <= '1';
                            indata <= indata(indata'high-1 downto 0) & spi_adc;
                            scount <= scount + 1;

                        when ST_ADC_LD_LO => 
                            spi_sck <= '0';

                        when ST_ADC_DONE => 
                            indata <= indata(indata'high-1 downto 0) & spi_adc;
                            adc_done <= '1';

                        when others => 
                            spi_mosi <= '0';
                    end case;
                end if;
            end if;
        end if;
    end process;

    state_controller_transitions : process(state, amp_cfg, scount, start_conv)
    begin
        case state is
            when ST_AMP_WAIT =>
                if ( amp_cfg = '1' ) then
                    state_next <= ST_AMP_START;
                else
                    state_next <= ST_AMP_WAIT;
                end if;

            when ST_AMP_START => 
                state_next <= ST_AMP_START_D;

            when ST_AMP_START_D => 
                state_next <= ST_AMP_LD_HI;

            when ST_AMP_LD_HI => 
                state_next <= ST_AMP_LD_LO;

            when ST_AMP_LD_LO => 
                if (scount = 7) then
                    state_next <= ST_AMP_DONE;
                else
                    state_next <= ST_AMP_LD_HI;
                end if;

            when ST_AMP_DONE => 
                state_next <= ST_ADC_WAIT;

            when ST_ADC_WAIT => 
                if ( start_conv = '1' ) then
                    state_next <= ST_ADC_START;
                else
                    state_next <= ST_ADC_WAIT;
                end if;

            when ST_ADC_START => 
                state_next <= ST_ADC_START_D;

            when ST_ADC_START_D => 
                state_next <= ST_ADC_LD_HI;

            when ST_ADC_LD_HI => 
                state_next <= ST_ADC_LD_LO;

            when ST_ADC_LD_LO => 
                if (scount = 34) then
                    state_next <= ST_ADC_DONE;
                else
                    state_next <= ST_ADC_LD_HI;
                end if;

            when ST_ADC_DONE => 
                state_next <= ST_ADC_WAIT;


            when others => 
                state_next <= ST_AMP_WAIT;

        end case;
    end process;

end amp_adc_arch;
