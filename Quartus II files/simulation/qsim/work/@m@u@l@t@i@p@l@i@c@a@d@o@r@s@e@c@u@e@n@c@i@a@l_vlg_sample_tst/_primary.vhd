library verilog;
use verilog.vl_types.all;
entity MULTIPLICADORSECUENCIAL_vlg_sample_tst is
    port(
        CLK             : in     vl_logic;
        nRST            : in     vl_logic;
        OPERANDO1       : in     vl_logic_vector(31 downto 0);
        OPERANDO2       : in     vl_logic_vector(31 downto 0);
        START           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end MULTIPLICADORSECUENCIAL_vlg_sample_tst;
