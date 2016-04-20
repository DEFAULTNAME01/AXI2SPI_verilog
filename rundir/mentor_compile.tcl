
# Set variables for compiling
set hdlDir ../hdl/
set tbDir ../tb/

# Comile the DUT
vlog hdlDir/axi2spi_bridge.v
vlog hdlDir/axi_interface.v
vlog hdlDir/spi_clock_generator.v
vlog hdlDir/spi_controller.v

# Compile the TB
vlog tbDir/test_bench.v


