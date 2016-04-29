
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
    output  [31:0]      AXI_rdata,     // read data
    input   [0:0]       AXI_rready,    // read ready
    output  [1:0]       AXI_rresp,     // read response
    output  [0:0]       AXI_rvalid,    // read valid
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
wire [31:0] w_data_to_registers;
wire w_wr_controll_reg, w_wr_data_reg;
wire [31:0] w_controll_reg;
wire [31:0] w_status_reg;
wire [31:0] w_data_reg;
wire        w_irq;

    
// Implementation of the AXI interface:
 axi_interface axi_interface_inst(
//CLK
    .FCLK_CLK0(FCLK_CLK0),
//RST
    // .RST_N(RST_N),
    
//Signals towards register interface:
    .o_data_to_registers(w_data_to_registers),
    .o_wr_controll_reg(w_wr_controll_reg),  // Offset: 0x00     
    .o_wr_data_reg(w_wr_data_reg),      // Offset: 0x08
    
    .i_controll_reg(w_controll_reg),
    .i_status_reg(w_status_reg),
    .i_data_reg(w_data_reg),
    
//AXI INTERFACE
    .AXI_araddr(AXI_araddr),    // read address address (data)
    .AXI_arprot(AXI_arprot),    // ???
    .AXI_arready(AXI_arready),   // read address ready
    .AXI_arvalid(AXI_arvalid),   // read address valid
    .AXI_awaddr(AXI_awaddr),    // write address address (channel data)
    .AXI_awprot(AXI_awprot),    // write address ??
    .AXI_awready(AXI_awready),   // write address ready
    .AXI_awvalid(AXI_awvalid),   // write address valid
    .AXI_bready(AXI_bready),    // (write) response ready  
    .AXI_bresp(AXI_bresp),     // write response   
    .AXI_bvalid(AXI_bvalid),    // write response valid 
    .AXI_rdata(AXI_rdata),     // read data
    .AXI_rready(AXI_rready),    // read ready
    .AXI_rresp(AXI_rresp),     // read response
    .AXI_rvalid(AXI_rvalid),    // read valid
    .AXI_wdata(AXI_wdata),     // write data
    .AXI_wready(AXI_wready),    // write ready
    .AXI_wstrb(AXI_wstrb),     // ??
    .AXI_wvalid(AXI_wvalid)     // write valid
    );
    


// Implementation of spi_controller:

spi_controller  spi_controller_inst(
//CLK
    .clk(FCLK_CLK0),
//RST
    .RST_N(RST_N),
//IRQ to AXI master
    .o_IRQ(w_irq),

//Signals towards AXI interface:
    .i_data_to_registers(w_data_to_registers),
    .i_wr_controll_reg(w_wr_controll_reg),  // Offset: 0x00     
    .i_wr_data_reg(w_wr_data_reg),      // Offset: 0x08
    .i_read_status_reg(w_read_status_reg),
    
    .o_controll_reg(w_controll_reg),
    .o_status_reg(w_status_reg),
    .o_data_reg(w_data_reg),
    
//SPI interface
    .i_miso(i_miso),
    .o_mosi(o_mosi),
    .o_sclk(o_sclk)
    
    );
    

endmodule