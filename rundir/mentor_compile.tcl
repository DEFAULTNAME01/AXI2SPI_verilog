
proc axi_spi_compile { } {
    # Set variables for compiling
    set hdlDir ../hdl/
    set tbDir ../tb/

    # Comile the DUT
    vlog $hdlDir/axi2spi_bridge.v
    vlog $hdlDir/axi_interface.v
    vlog $hdlDir/spi_clock_generator.v
    vlog $hdlDir/spi_controller.v

    # Compile the TB
    vlog -sv $tbDir/test_bench.v
    vlog -sv $tbDir/eeprom_model/M95XXX_Memory.v
    vlog -sv $tbDir/eeprom_model/M95XXX_Macro_mux.v
}

proc axi_spi_sim { } {
    vsim simulation_top -novopt
}

proc axi_spi_wave { } {
    do wave.do
}


proc axi_spi_run { } {
    # Create and open a VCD file
    vcd file dump.vcd
    # Add VHDL signals (i.e. in this case, recursively add all signals)
    vcd add -r *
    
    # run 10000ns
    run 100us
    
    #################################################
    ### VCD File Control - Dump all VCD variables ###
    #################################################

    #    Flush contents of VCD file buffer to VCD file
    # vcd flush 
    vcd checkpoint

    # Turn off VCD dumping
    # vcd off
}

proc axi_spi_all { } {
    axi_spi_compile
    axi_spi_sim
    axi_spi_wave
    axi_spi_run
}

proc close_vcd { } {
    restart
}

axi_spi_all