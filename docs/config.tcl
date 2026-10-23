# Starter configuration for classic OpenLane 1.x.
# Copy this folder as a design directory under the OpenLane designs directory.
set ::env(DESIGN_NAME) "cold_chain_temp_monitor"
set ::env(VERILOG_FILES) [list $::env(DESIGN_DIR)/src/cold_chain_temp_monitor.v]
set ::env(CLOCK_PORT) "clk"
set ::env(CLOCK_PERIOD) "10"
set ::env(FP_SIZING) "absolute"
set ::env(DIE_AREA) "0 0 100 100"
set ::env(PL_TARGET_DENSITY) 0.35
set ::env(FP_PIN_ORDER_CFG) $::env(DESIGN_DIR)/pin_order.cfg
