-- bt - hardware beat tracker
-- top level module

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;
use work.dsize_pkg.all;

entity project is
    port (
        clk_50m : in  std_logic;
        
        led : out std_logic_vector(7 downto 0);

        sw        : in  std_logic_vector(3 downto 0);
        btn_east  : in  std_logic;
        btn_north : in  std_logic;
        btn_south : in  std_logic;
        btn_west  : in  std_logic;

        rs232_dce_rxd : in  std_logic;
        rs232_dce_txd : out std_logic;

        spi_sck  : out std_logic;
        spi_mosi : out std_logic;
        spi_miso : in  std_logic;
        amp_out  : in  std_logic;
        dac_out  : in  std_logic;
        adc_out  : in  std_logic;
        
        spi_ss_b : out std_logic;
        alt_ss_b : out std_logic;
        amp_cs   : out std_logic;
        dac_cs   : out std_logic;
        ad_conv  : out std_logic;

        amp_shdn      : out std_logic;
        dac_clr       : out std_logic;
        st_spi_wp     : out std_logic;
        dataflash_wp  : out std_logic;
        dataflash_rst : out std_logic;

        fpga_init_b : out std_logic
    );
end project;

architecture project_arch of project is

    signal clk25, clk50    : std_logic;
    signal rst, clk_locked, clk_rst : std_logic;
    signal rst_dcount : unsigned(5 downto 0);

    signal uart_din, uart_dout : std_logic_vector(7 downto 0);
    signal uart_wr, uart_rd, uart_rda, uart_tbe : std_logic;

    signal amp_cfg, adc_start, amp_done, adc_done : std_logic;
    signal amp_gain     : std_logic_vector(7 downto 0);
    signal adc_a, adc_b : std_logic_vector(13 downto 0);

    signal sample_rdy, sample_rd : std_logic;
    signal sample : std_logic_vector(SAMPLE_WIDTH-1 downto 0);

    signal cs_control : std_logic_vector(35 downto 0);
    signal cs_data : std_logic_vector(127 downto 0);
    signal cs_trig : std_logic_vector(7 downto 0);

begin

    -- set up clocking and reset
    clocking_inst : entity clocking
        port map (
            clk_in  => clk_50m,
            rst     => '0',
            clk1x   => clk50,
            clk_div => clk25,
            lock    => clk_locked
        );

    -- hold clocking reset for a few clock cycles to let things settle
    rst_hold : process(clk50)
    begin
        if (rising_edge(clk50)) then
            if (clk_locked = '0') then
                clk_rst <= '1';
                rst_dcount <= (others => '0');
            else
                if (rst_dcount = to_unsigned(2**(rst_dcount'length) - 1,
                                    rst_dcount'length)) then
                    clk_rst <= '0';
                    rst_dcount <= (others => '0');
                else
                    rst_dcount <= rst_dcount + 1;
                end if;
            end if;
        end if;
    end process;

    rst <= btn_south or clk_rst;


    -- disable other devices on the spi line
    spi_ss_b <= '1';
    alt_ss_b <= '1';
    dac_cs   <= '1';

    st_spi_wp     <= '0';
    dataflash_wp  <= '0';
    dataflash_rst <= '0';
    dac_clr       <= '1';

    -- yay we're configured
    fpga_init_b <= '0';


    -- led control
    process (clk50)
    begin
        if (rising_edge(clk50)) then
            if (sample_rdy = '1') then
                if sample(sample'high) = '1' then
                    led <= not sample(sample'high-1 downto sample'high-8);
                else
                    led <= sample(sample'high-1 downto sample'high-8);
                end if;
            end if;
        end if;
    end process;


    -- uart receiver and transmitter
    uart_inst : entity Rs232RefComp
        generic map (
            --baudDivide => x"A3"
            baudDivide => x"0D" -- 115200
        )
        port map (
            txd => rs232_dce_txd,
            rxd => rs232_dce_rxd,
            clk => clk50,
            rst => rst,
            
            dbin => uart_din,
            wr   => uart_wr,

            dbout => uart_dout,
            rd    => uart_rda,
            pe    => open,
            fe    => open,
            oe    => open,

            rda => uart_rda,
            tbe => uart_tbe
        );


    -- pre-amp and adc controller
    amp_shdn <= '0';
    amp_adc_inst : entity amp_adc
        port map (
            clk => clk50,
            rst => rst,

            amp_cfg  => amp_cfg,
            gain     => amp_gain,
            amp_done => amp_done,

            start_conv => adc_start,
            adc_done   => adc_done,
            adc_a      => adc_a,
            adc_b      => adc_b,

            amp_cs    => amp_cs,
            adc_start => ad_conv,
            spi_sck   => spi_sck,
            spi_mosi  => spi_mosi,
            spi_adc   => adc_out,
            spi_amp   => amp_out
        );


    -- sample injector
    sample_injector_inst : entity sample_injector
        port map (
            clk => clk50,
            rst => rst,

            amp_cfg   => amp_cfg,
            adc_start => adc_start,
            gain      => amp_gain,
            
            amp_done => amp_done,
            adc_done => adc_done,
            adc_a    => adc_a,
            adc_b    => adc_b,

            sample_rdy => sample_rdy,
            sample     => sample,
            sample_rd  => sample_rd
        );

    -- main processor

    -- tempo extractor

    -- blinky LEDs

    -- serial output
    process (clk50)
    begin
        if (rising_edge(clk50)) then
            if (rst = '1') then
                uart_din <= (others => '0');
                uart_wr  <= '0';
            else

                if (sample_rdy = '1') then
                    uart_din <= sample(sample'high downto sample'high-7);
                    uart_wr  <= uart_tbe;
                    sample_rd <= '1';
                else
                    uart_wr <= '0';
                    sample_rd <= '0';
                end if;

            end if;
        end if;
    end process;

--    chipscope_icon_inst : entity chipscope_icon
--        port map (
--            CONTROL0 => cs_control
--        );
--
--    chipscope_ila_inst : entity chipscope_ila
--        port map (
--            CONTROL => cs_control,
--            CLK => clk50,
--            DATA => cs_data,
--            TRIG0 => cs_trig
--        );
--
--    reg_ila : process(clk50)
--    begin
--        if (rising_edge(clk50)) then
--            if (rst='1') then
--                cs_trig <= (others => '0');
--                cs_data <= (others => '0');
--
--            else 
--                cs_trig <= (7 downto 0 => '0');
--                cs_data <= (127 downto 0 => '0');
--            end if;
--        end if;
--    end process;

end architecture;
