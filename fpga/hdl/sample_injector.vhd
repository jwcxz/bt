-- bt - hardware beat tracker
-- sample injector -- controls data sampling

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;
use work.dsize_pkg.all;

entity sample_injector is
    generic (
        ADC_GAIN : std_logic_vector(7 downto 0) := x"11"
    );
    port (
        dbg_state : out std_logic_vector(3 downto 0);
        dbg_start : out std_logic;

        clk : in  std_logic;
        rst : in  std_logic;

        amp_cfg   : out std_logic;
        adc_start : out std_logic;
        gain      : out std_logic_vector(7 downto 0);

        amp_done  : in  std_logic;
        adc_done  : in  std_logic;
        adc_a     : in  std_logic_vector(13 downto 0);
        adc_b     : in  std_logic_vector(13 downto 0);

        sample_rdy : out std_logic;
        sample     : out std_logic_vector(2*SAMPLE_WIDTH-1 downto 0);
        sample_rd  : in  std_logic
    );
end sample_injector;

architecture sample_injector_arch of sample_injector is
    type state_type is (
        ST_INIT,
        ST_INIT_D,
        ST_READY,
        ST_CONVERTING,
        ST_CONVERTING_D,
        ST_CONVDONE
    );

    signal state_next, state : state_type;

    signal start_conv  : std_logic;
    signal pulse_count : unsigned(SAMPLE_COUNT_WIDTH-1 downto 0);

    signal dbg_x, dbg_y : std_logic_vector(7 downto 0);
begin
    dbg_state <= x"0" when state = ST_INIT else
           x"1" when state = ST_INIT_D else
           x"2" when state = ST_READY else
           x"3" when state = ST_CONVERTING else
           x"4" when state = ST_CONVERTING_D else
           x"5" when state = ST_CONVDONE else
           x"F";

    dbg_start <= start_conv;

    gain <= ADC_GAIN;

    sample_pulsegen : process(clk)
    begin
        if (rising_edge(clk)) then
        if (rst = '1') then
            pulse_count <= (others => '0');
        else
            -- TODO: reset on state change? meh
            if pulse_count = SAMPLE_COUNT_MAX then
                pulse_count <= (others => '0');
                start_conv <= '1';
            else
                pulse_count <= pulse_count + to_unsigned(1, pulse_count'length);
                start_conv <= '0';
            end if;
        end if;
        end if;
    end process;

    state_controller_seq  : process(clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                amp_cfg   <= '0';
                adc_start <= '0';
                
                sample_rdy <= '0';
                sample <= (others => '0');

                state <= ST_INIT;
            else
                state <= state_next;

                if state = ST_INIT then
                    amp_cfg <= '1';
                else
                    amp_cfg <= '0';
                end if;

                if state = ST_CONVERTING then
                    adc_start <= '1';
                else
                    adc_start <= '0';
                end if;

                if state = ST_CONVDONE then
                    sample_rdy <= '1';
                    sample <= adc_a & adc_a;
                else
                    sample_rdy <= '0';
                end if;
            end if;
        end if;
    end process;


    state_controller_transitions : process(state, amp_done, start_conv, adc_done, sample_rd)
    begin
        case state is
            when ST_INIT => 
                state_next <= ST_INIT_D;

            when ST_INIT_D => 
                if amp_done = '1' then
                    state_next <= ST_READY;
                else
                    state_next <= ST_INIT_D;
                end if;

            when ST_READY => 
                if start_conv = '1' then
                    state_next <= ST_CONVERTING;
                else
                    state_next <= ST_READY;
                end if;

            when ST_CONVERTING => 
                state_next <= ST_CONVERTING_D;

            when ST_CONVERTING_D => 
                if adc_done = '1' then
                    state_next <= ST_CONVDONE;
                else
                    state_next <= ST_CONVERTING_D;
                end if;

            when ST_CONVDONE => 
                if sample_rd = '1' then
                    state_next <= ST_READY;
                else
                    state_next <= ST_CONVDONE;
                end if;

            when others => 
                state_next <= ST_INIT;
        end case;
    end process;

end sample_injector_arch;
