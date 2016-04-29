
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
    reg [6:0] q_spi_sclk_cntr;
	wire w_sclk_internal;
	wire [1:0]w_clk_select;
	reg q_sclk_internal_d1;     //alwaysbe reg, d1->eggyel kesleltetett
	wire w_sclk_rising_edge_internal;
	wire w_sclk_falling_edge_internal;
	wire w_sample_spi_data_internal;
	wire w_setup_spi_data;
	wire [1:0] w_sample_setup_select;

    
	always @(posedge i_clk) begin : SCLK_CNTR
		if (i_reset) begin
			q_spi_sclk_cntr <= 7'b0 ;
		end else  begin
			q_spi_sclk_cntr <= q_spi_sclk_cntr + 1;
		end
	end	
	
	assign w_clk_select={i_spr0,i_spr1};
	
	assign w_sclk_internal = (w_clk_select==0) ? q_spi_sclk_cntr[1] :
							 (w_clk_select==1) ? q_spi_sclk_cntr[3] :
							 (w_clk_select==2) ? q_spi_sclk_cntr[5] :
							 (w_clk_select==3) ? q_spi_sclk_cntr[6] :
							  0; // soha nem jut ide
							  
	assign o_sclk = w_sclk_internal;	
	
	always @(posedge i_clk) begin : SCLK_EDGE_DETECT
		if (i_reset) begin
			q_sclk_internal_d1<=0;
		end
		else begin 
			q_sclk_internal_d1 <=w_sclk_internal;
		end
	end
	
	//felfuto el
	assign w_sclk_rising_edge_internal = (w_sclk_internal > q_sclk_internal_d1) ? 1:
										 0;												//ha nagyobb az aktualis, mint az elozo ->felfuto
										 
	assign o_sclk_rising_edge = w_sclk_rising_edge_internal;
	
	//lefuto el
	assign w_sclk_falling_edge_internal = (w_sclk_internal < q_sclk_internal_d1) ? 1:
										 0;												//ha kisebb ->lefuto

	assign o_sclk_falling_edge = w_sclk_falling_edge_internal;
	
	assign w_sample_setup_select={i_cpol,i_cpha};
	
	//o_sample_spi_data
	assign w_sample_spi_data_internal = (w_sample_setup_select==0) ? w_sclk_rising_edge_internal:
										(w_sample_setup_select==1) ? w_sclk_falling_edge_internal:
										(w_sample_setup_select==2) ? w_sclk_falling_edge_internal:
										(w_sample_setup_select==3) ? w_sclk_rising_edge_internal:
										0;
	
	assign o_sample_spi_data = w_sample_spi_data_internal;
	
	//o_setup_spi_data
	assign w_setup_spi_data = 	(w_sample_setup_select==0) ? w_sclk_falling_edge_internal:
								(w_sample_setup_select==1) ? w_sclk_rising_edge_internal:
								(w_sample_setup_select==2) ? w_sclk_rising_edge_internal:
								(w_sample_setup_select==3) ? w_sclk_falling_edge_internal:
								0;
								
	assign o_setup_spi_data = w_setup_spi_data;
	
    // -- TODO --
    
    
endmodule