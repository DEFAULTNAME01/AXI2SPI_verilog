
module spi_clock_generator(
//CLK
    // i_clk is the system clock (10-200MHz)
    input   i_clk,
//RST
    // i_reset is the system reset. This is a active high signal.
    //      '1' : reset is active
    input   i_reset,
    
//Controll inputs from registers
    input   i_spr0,
    input   i_spr1,
    input   i_cpol,
    input   i_cpha,
    input   i_mstr,
    
// Controll output to other logic
    // o_sclk: This is the SPI clock. The polarity based on the i_cpol
    //          The frequency is derived by i_spr0 and i_spr1
    output  o_sclk,
    // o_sclk_rising_edge: is active one sys clk long at the rising edge of
    //      the sclk.
    output  o_sclk_rising_edge,
    // o_sclk_falling_edge: is active one sys clk long at the falling edge of
    //      the sclk.
    output  o_sclk_falling_edge,
    // o_sample_spi_data: is active one sys clk long at an edge of the spi slck
    //      i_cpha and i_cpol describe if it is the rising or the falling edge.
    output  o_sample_spi_data,
    // o_setup_spi_data: is active one sys clk long at an edge of the spi slck
    //      i_cpha and i_cpol describe if it is the rising or the falling edge.
    //      Note that this is the alter edge than o_sample_spi_data
    output  o_setup_spi_data
    
    );
    
    // The spi clock counter. The max value is depends on the frequency which
    // derived by i_spr0 and i_spr1 
    reg [31:0] q_spi_sclk_cntr;
    
    
    // -- TODO --
    
    
endmodule