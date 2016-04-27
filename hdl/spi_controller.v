
module spi_controller(
//CLK
    input   clk,
//RST
    input   RST_N,
//IRQ to AXI master
    output  o_IRQ,

//Signals towards AXI interface:
    input   wire [31:0] i_data_to_registers,
    input   wire        i_wr_controll_reg,  // Offset: 0x00     
    input   wire        i_wr_data_reg,      // Offset: 0x08
    input   wire        i_read_status_reg,
    
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
wire [31:0] w_status_reg;
reg [7:0] q_data_reg;

// clock and reset:
wire clk;
wire reset;

// SPI controller resister:
reg [7:0]   q_spi_bit_cntr;
//Do not use in first implementation. This is a future feature...
reg [2:0]   q_spi_byte_cntr; 
//IRQ flag
reg         q_irq_flag;
//collision flag
reg        q_collision_flag;

reg [7:0]  q_spi_mosi_shr;
reg [7:0]  q_spi_miso_shr;

wire w_setup_spi_data;
wire w_sample_spi_data;
wire w_active_spi_transaction;
wire w_reset;


// Concurrent assignments.
assign clk      = FCLK_CLK0;
assign reset    = ~RST_N;
assign o_controll_reg   = q_controll_reg;
assign o_status_reg     = w_status_reg;
assign o_data_reg       = q_data_reg;
assign w_reset          = ~RST_N;


// Instance of the Clock generator 


spi_clock_generator spi_clock_generator_inst(
//CLK
    // i_clk is the system clock (10-200MHz)
    .i_clk(i_clk),
//RST
    // i_reset is the system reset. This is a active high signal.
    //      '1' : reset is active
    .i_reset(w_reset),
    
//Controll inputs from registers
    .i_spr0(i_spr0),
    .i_spr1(i_spr1),
    .i_cpol(i_cpol),
    .i_cpha(i_cpha),
    .i_mstr(i_mstr),
    
// Controll output to other logic
    // o_sclk: This is the SPI clock. The polarity based on the i_cpol
    //          The frequency is derived by i_spr0 and i_spr1
    .o_sclk(o_sclk),
    // o_sclk_rising_edge: is active one sys clk long at the rising edge of
    //      the sclk.
    .o_sclk_rising_edge(),
    // o_sclk_falling_edge: is active one sys clk long at the falling edge of
    //      the sclk.
    .o_sclk_falling_edge(),
    // o_sample_spi_data: is active one sys clk long at an edge of the spi slck
    //      i_cpha and i_cpol describe if it is the rising or the falling edge.
    .o_sample_spi_data(w_sample_spi_data),
    // o_setup_spi_data: is active one sys clk long at an edge of the spi slck
    //      i_cpha and i_cpol describe if it is the rising or the falling edge.
    //      Note that this is the alter edge than o_sample_spi_data
    .o_setup_spi_data(w_setup_spi_data)
    
    );


///////////////////////////////////////////////////////////////////////////
// The internal register interface. The following blocks drive all internal
// registers.

// Status register:
assign w_status_reg = {q_irq_flag, q_collision_flag, 6'b0};

// control register
always @(posedge clk) begin
    if(i_wr_controll_reg) begin
        q_controll_reg <= i_data_to_registers;
    end
    
end

//data register
always @(posedge clk) begin
    if(i_wr_data_reg) begin
        q_data_reg <= i_data_to_registers;
    end
    if(w_active_spi_transaction) begin
        if(w_setup_spi_data) begin
            if(w_dword) begin
                q_data_reg <= {1'b0, q_data_reg[7:1]}
            end else begin
                q_data_reg <= {q_data_reg[6:0], 1'b0}
            end
        end
    end
end
 


///////////////////////////////////////////////////////////////////////////
// SPI controller blocks:
    
    
// bit_counter
always @(posedge clk) begin
    if(w_reset) begin
        q_spi_bit_cntr <= 8;
    end else begin
        if (i_wr_data_reg) begin
            q_spi_bit_cntr <= 0;
        end else begin
            if(w_sample_spi_data) begin
                if(q_spi_bit_cntr != 8)
                    q_spi_bit_cntr <= q_spi_bit_cntr + 1;
            end
        end
    end
end

assign w_active_spi_transaction = q_spi_bit_cntr <8;


 //interrupt flag
always @(posedge clk) begin
    if(q_spi_bit_cntr == 7 && w_sample_spi_data) begin
        q_irq_flag <= 1'b1;
    end else begin
        if(i_read_status_reg)
            q_irq_flag <= 1'b0;
    end
end
 
assign o_IRQ = q_irq_flag;
 
 //collision flag
always @(posedge clk) begin
    if(w_active_spi_transaction) begin
        if(i_wr_controll_reg | i_wr_data_reg)
            q_collision_flag <= 1'b1;
    end else begin
        if(i_read_status_reg)
            q_collision_flag <= 1'b0;
    end
end
 
 //miso shr
always @(posedge clk) begin
    if(w_sample_spi_data) begin
        if(w_dword) begin
            q_spi_miso_shr <= {i_miso, q_spi_miso_shr[7:1]}
        end else begin
            q_spi_miso_shr <= {q_spi_miso_shr[6:0], i_miso}
        end
    end   
end

assign o_mosi = w_dword ? (q_data_reg[0]) : q_data_reg[7];
 
 
endmodule