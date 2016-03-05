
module spi_controller(
//CLK
    input   FCLK_CLK0,
//RST
    input   RST_N,
//IRQ to AXI master
    output  IRQ,

//Signals towards AXI interface:
    input   wire [31:0] i_data_to_registers,
    input   wire        i_wr_controll_reg,  // Offset: 0x00     
    input   wire        i_wr_data_reg,      // Offset: 0x08
    
    output  wire [31:0] o_controll_reg,
    output  wire [31:0] o_status_reg,
    output  wire [31:0] o_data_reg,
    
//SPI interface
    input   i_miso,
    output  o_mosi,
    output  o_sclk
    
    );
    
///////////////////////////////////////////////////////////////////////////////
// Signal declaration:
    
// The registers of rhis SPI peripheral.
reg [31:0] q_controll_reg;
reg [31:0] q_status_reg;
reg [31:0] q_data_reg;

// clock and reset:
wire clk;
wire reset;

// SPI controller resister:
reg [7:0]   q_spi_bit_cntr;
//Do not use in first implementation. This is a future feature...
reg [2:0]   q_spi_byte_cntr; 



// Concurrent assignments.
assign clk      = FCLK_CLK0;
assign reset    = ~RST_N;
assign o_controll_reg   = q_controll_reg;
assign o_status_reg     = q_status_reg;
assign o_data_reg       = q_data_reg;


// Instance of the Clock generator 

// -- TODO --


///////////////////////////////////////////////////////////////////////////
// The internal register interface. The following blocks drive all internal
// registers.

// Status register:
always @(posedge clk) begin
    // -- TODO --
end

// control register
always @(posedge clk) begin
    // -- TODO --
end

//data register
always @(posedge clk) begin
    // -- TODO --
end
 


///////////////////////////////////////////////////////////////////////////
// SPI controller blocks:
    
    
// bit_counter
always @(posedge clk) begin
    // -- TODO --
end
 
 
// IRQ: drive IRQ when it enabled and there is an active interrupt.
always @(posedge clk) begin
    // -- TODO --
end
    
endmodule