
module axi2spi_bridge(
//CLK
    input   FCLK_CLK0,
//RST
    input   RST_N,
    
    
//AXI INTERFACE
    input   [31:0]      AXI_araddr,    // read address address (data)
    input   [2:0]       AXI_arprot,    // ???
    output  [0:0]       AXI_arready,   // read address ready
    input   [0:0]       AXI_arvalid,   // read address valid
    input   [31:0]      AXI_awaddr,    // write address address (channel data)
    input   [2:0]       AXI_awprot,    // write address ??
    output  [0:0]       AXI_awready,   // write address ready
    input   [0:0]       AXI_awvalid,   // write address valid
    input   [0:0]       AXI_bready,    // (write) response ready  
    output  [1:0]       AXI_bresp,     // write response   
    output  [0:0]       AXI_bvalid,    // write response valid 
    output reg [31:0]   AXI_rdata,     // read data
    input   [0:0]       AXI_rready,    // read ready
    output  [1:0]       AXI_rresp,     // read response
    output reg [0:0]    AXI_rvalid,    // read valid
    input   [31:0]      AXI_wdata,     // write data
    output  [0:0]       AXI_wready,    // write ready
    input   [3:0]       AXI_wstrb,     // ??
    input   [0:0]       AXI_wvalid,     // write valid
//IRQ to AXI master
    output  IRQ,

//SPI interface
    input   i_miso,
    output  o_mosi,
    output  o_sclk
    );

// Signal declarations to connect AXI to spi controller:
// -- TODO --
    
    
// Implementation of the AXI interface:
// -- TODO --


// Implementation of spi_controller:
// -- TODO --

endmodule