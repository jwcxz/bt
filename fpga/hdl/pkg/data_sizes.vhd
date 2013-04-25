library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package dsize_pkg is

    constant SAMPLE_WIDTH : integer := 14;

    --constant SAMPLE_COUNT_MAX   : integer := 250000;
    --constant SAMPLE_COUNT_MAX   : integer := 4545;
    constant SAMPLE_COUNT_MAX   : integer := 521;

    constant SAMPLE_COUNT_WIDTH : integer := 10;

end dsize_pkg;
