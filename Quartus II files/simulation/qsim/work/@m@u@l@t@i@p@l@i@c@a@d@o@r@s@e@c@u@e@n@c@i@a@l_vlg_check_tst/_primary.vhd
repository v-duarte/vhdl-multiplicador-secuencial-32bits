library verilog;
use verilog.vl_types.all;
entity MULTIPLICADORSECUENCIAL_vlg_check_tst is
    port(
        READY           : in     vl_logic;
        RESULTADO       : in     vl_logic_vector(63 downto 0);
        S0              : in     vl_logic;
        S1              : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end MULTIPLICADORSECUENCIAL_vlg_check_tst;
