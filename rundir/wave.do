onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group BridgeTopIO /simulation_top/axi_spi_DUT/FCLK_CLK0
add wave -noupdate -expand -group BridgeTopIO /simulation_top/axi_spi_DUT/IRQ
add wave -noupdate -expand -group BridgeTopIO /simulation_top/axi_spi_DUT/RST_N
add wave -noupdate -expand -group BridgeTopIO -expand -group AXI /simulation_top/axi_spi_DUT/AXI_awvalid
add wave -noupdate -expand -group BridgeTopIO -expand -group AXI /simulation_top/axi_spi_DUT/AXI_bready
add wave -noupdate -expand -group BridgeTopIO -expand -group AXI /simulation_top/axi_spi_DUT/AXI_bresp
add wave -noupdate -expand -group BridgeTopIO -expand -group AXI /simulation_top/axi_spi_DUT/AXI_bvalid
add wave -noupdate -expand -group BridgeTopIO -expand -group AXI /simulation_top/axi_spi_DUT/AXI_rdata
add wave -noupdate -expand -group BridgeTopIO -expand -group AXI /simulation_top/axi_spi_DUT/AXI_rready
add wave -noupdate -expand -group BridgeTopIO -expand -group AXI /simulation_top/axi_spi_DUT/AXI_rresp
add wave -noupdate -expand -group BridgeTopIO -expand -group AXI /simulation_top/axi_spi_DUT/AXI_rvalid
add wave -noupdate -expand -group BridgeTopIO -expand -group AXI /simulation_top/axi_spi_DUT/AXI_wdata
add wave -noupdate -expand -group BridgeTopIO -expand -group AXI /simulation_top/axi_spi_DUT/AXI_wready
add wave -noupdate -expand -group BridgeTopIO -expand -group AXI /simulation_top/axi_spi_DUT/AXI_wstrb
add wave -noupdate -expand -group BridgeTopIO -expand -group AXI /simulation_top/axi_spi_DUT/AXI_wvalid
add wave -noupdate -expand -group BridgeTopIO -expand -group AXI /simulation_top/axi_spi_DUT/AXI_arprot
add wave -noupdate -expand -group BridgeTopIO -expand -group AXI /simulation_top/axi_spi_DUT/AXI_arready
add wave -noupdate -expand -group BridgeTopIO -expand -group AXI /simulation_top/axi_spi_DUT/AXI_arvalid
add wave -noupdate -expand -group BridgeTopIO -expand -group AXI /simulation_top/axi_spi_DUT/AXI_awaddr
add wave -noupdate -expand -group BridgeTopIO -expand -group AXI /simulation_top/axi_spi_DUT/AXI_awprot
add wave -noupdate -expand -group BridgeTopIO -expand -group AXI /simulation_top/axi_spi_DUT/AXI_awready
add wave -noupdate -expand -group BridgeTopIO -expand -group AXI /simulation_top/axi_spi_DUT/AXI_araddr
add wave -noupdate -expand -group BridgeTopIO -expand -group SPI /simulation_top/axi_spi_DUT/o_sclk
add wave -noupdate -expand -group BridgeTopIO -expand -group SPI /simulation_top/axi_spi_DUT/o_mosi
add wave -noupdate -expand -group BridgeTopIO -expand -group SPI /simulation_top/axi_spi_DUT/i_miso
add wave -noupdate /simulation_top/spi_select
add wave -noupdate -expand -group axi_interfaceIO /simulation_top/axi_spi_DUT/axi_interface_inst/AXI_araddr
add wave -noupdate -expand -group axi_interfaceIO /simulation_top/axi_spi_DUT/axi_interface_inst/AXI_arprot
add wave -noupdate -expand -group axi_interfaceIO /simulation_top/axi_spi_DUT/axi_interface_inst/AXI_arready
add wave -noupdate -expand -group axi_interfaceIO /simulation_top/axi_spi_DUT/axi_interface_inst/AXI_arvalid
add wave -noupdate -expand -group axi_interfaceIO /simulation_top/axi_spi_DUT/axi_interface_inst/AXI_awaddr
add wave -noupdate -expand -group axi_interfaceIO /simulation_top/axi_spi_DUT/axi_interface_inst/AXI_awprot
add wave -noupdate -expand -group axi_interfaceIO /simulation_top/axi_spi_DUT/axi_interface_inst/AXI_awready
add wave -noupdate -expand -group axi_interfaceIO /simulation_top/axi_spi_DUT/axi_interface_inst/AXI_awvalid
add wave -noupdate -expand -group axi_interfaceIO /simulation_top/axi_spi_DUT/axi_interface_inst/AXI_bready
add wave -noupdate -expand -group axi_interfaceIO /simulation_top/axi_spi_DUT/axi_interface_inst/AXI_bresp
add wave -noupdate -expand -group axi_interfaceIO /simulation_top/axi_spi_DUT/axi_interface_inst/AXI_bvalid
add wave -noupdate -expand -group axi_interfaceIO /simulation_top/axi_spi_DUT/axi_interface_inst/AXI_rdata
add wave -noupdate -expand -group axi_interfaceIO /simulation_top/axi_spi_DUT/axi_interface_inst/AXI_rready
add wave -noupdate -expand -group axi_interfaceIO /simulation_top/axi_spi_DUT/axi_interface_inst/AXI_rresp
add wave -noupdate -expand -group axi_interfaceIO /simulation_top/axi_spi_DUT/axi_interface_inst/AXI_rvalid
add wave -noupdate -expand -group axi_interfaceIO /simulation_top/axi_spi_DUT/axi_interface_inst/AXI_wdata
add wave -noupdate -expand -group axi_interfaceIO /simulation_top/axi_spi_DUT/axi_interface_inst/AXI_wready
add wave -noupdate -expand -group axi_interfaceIO /simulation_top/axi_spi_DUT/axi_interface_inst/AXI_wstrb
add wave -noupdate -expand -group axi_interfaceIO /simulation_top/axi_spi_DUT/axi_interface_inst/AXI_wvalid
add wave -noupdate -expand -group axi_interfaceIO /simulation_top/axi_spi_DUT/axi_interface_inst/FCLK_CLK0
add wave -noupdate -expand -group axi_interfaceIO /simulation_top/axi_spi_DUT/axi_interface_inst/clk
add wave -noupdate -expand -group axi_interfaceIO /simulation_top/axi_spi_DUT/axi_interface_inst/i_controll_reg
add wave -noupdate -expand -group axi_interfaceIO /simulation_top/axi_spi_DUT/axi_interface_inst/i_data_reg
add wave -noupdate -expand -group axi_interfaceIO /simulation_top/axi_spi_DUT/axi_interface_inst/i_status_reg
add wave -noupdate -expand -group axi_interfaceIO /simulation_top/axi_spi_DUT/axi_interface_inst/o_data_to_registers
add wave -noupdate -expand -group axi_interfaceIO /simulation_top/axi_spi_DUT/axi_interface_inst/o_wr_controll_reg
add wave -noupdate -expand -group axi_interfaceIO /simulation_top/axi_spi_DUT/axi_interface_inst/o_wr_data_reg
add wave -noupdate -expand -group interanl /simulation_top/axi_spi_DUT/spi_controller_inst/q_spi_bit_cntr
add wave -noupdate -expand -group interanl /simulation_top/axi_spi_DUT/spi_controller_inst/spi_clock_generator_inst/i_reset
add wave -noupdate -expand -group interanl /simulation_top/axi_spi_DUT/spi_controller_inst/w_active_spi_transaction
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {91732635 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {10500 ns}
