library verilog;
use verilog.vl_types.all;
entity MULTIPLICADORSECUENCIAL is
    port(
        S1              : out    vl_logic;
        START           : in     vl_logic;
        nRST            : in     vl_logic;
        CLK             : in     vl_logic;
        S0              : out    vl_logic;
        READY           : out    vl_logic;
        RESULTADO       : out    vl_logic_vector(63 downto 0);
        OPERANDO2       : in     vl_logic_vector(31 downto 0);
        OPERANDO1       : in     vl_logic_vector(31 downto 0)
    );
end MULTIPLICADORSECUENCIAL;
