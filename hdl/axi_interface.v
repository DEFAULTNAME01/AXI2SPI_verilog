`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
//////////////////////////////////////////////////////////////////////////////////

`define ADDR_CONTROL_REG    'h0
`define ADDR_STATUS_REG     'h1
`define ADDR_DATA_REG       'h2

module axi_interface(
//CLK
    input   FCLK_CLK0,
//RST
    input   RST_N,
    
//Signals towards register interface:
    output  wire [31:0] o_data_to_registers,
    output  wire        o_wr_controll_reg,  // Offset: 0x00     
    output  wire        o_wr_data_reg,      // Offset: 0x08
    
    input   wire [31:0] i_controll_reg,
    input   wire [31:0] i_status_reg,
    input   wire [31:0] i_data_reg,
    
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
    input   [0:0]       AXI_wvalid     // write valid
    );
    

wire clk;
//wire reset;

//assign reset = ~RST_N;
assign clk = FCLK_CLK0;

       
assign o_data_to_registers <= AXI_wdata[31:0];
/// AXI interface

// WRITE  --  this block control the enable of registers to write them from AXI
// Note that the second assignment will be valid in verilog.
always @(*) begin
    o_wr_data_reg <= '0;
    o_wr_controll_reg <= '0;
    if (AXI_awvalid[0] & AXI_wvalid[0]) begin
        if(AXI_awaddr[15:2] == `ADDR_CONTROL_REG) // BASE + 0x00
            o_wr_controll_reg <= '1
        if(AXI_awaddr[15:2] == `ADDR_DATA_REG) // BASE + 0x08
            o_wr_data_reg <= '1;
    end
end
    
    
assign AXI_awready[0] = AXI_awvalid[0] & AXI_wvalid[0];   // AXI_awvalid;
assign AXI_wready[0]  = AXI_awvalid[0] & AXI_wvalid[0];   // AXI_awvalid;
assign AXI_bvalid[0]  = AXI_awvalid[0] & AXI_wvalid[0]; 	// 1'b1;

assign AXI_bresp[0]   = 'h0;


// READ  --  this module gives the DATA
always @(posedge clk) begin
    AXI_rdata <= data_from_registers;
end

// READ  --  this block drive the AXI when the AXI bus-master reads a data.
always @(posedge clk) begin
    if (AXI_arvalid[0])
        if(AXI_araddr[15:2] == `ADDR_CONTROL_REG) // BASE + 0x00
            AXI_rdata <= i_controll_reg,
        if(AXI_araddr[15:2] ==  `ADDR_STATUS_REG) // BASE + 0x04
            AXI_rdata <= i_status_reg;
        if(AXI_araddr[15:2] == `ADDR_DATA_REG) // BASE + 0x08
            AXI_rdata <= i_data_reg;
end

always @(posedge clk) begin
    AXI_rvalid[0] <= AXI_rready[0] & ~AXI_rvalid[0];
end
 
assign AXI_arready[0] = AXI_arvalid[0];


assign AXI_rresp[0]   = 'h0;


endmodule



