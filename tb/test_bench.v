/******************************************************************************
 *
******************************************************************************/


module simulation_top ()

/**
 * Signal definitions to connect the DUT.
*/
wire sclk, mosi, miso;
reg spi_select;

reg sys_clk, rst_n;
reg   [31:0]      q_AXI_araddr;    // read address address (data)
reg   [2:0]       q_AXI_arprot;    // ???
wire  [0:0]       w_AXI_arready;   // read address ready
reg   [0:0]       q_AXI_arvalid;   // read address valid
reg   [31:0]      q_AXI_awaddr;    // write address address (channel data)
reg   [2:0]       q_AXI_awprot;    // write address ??
wire  [0:0]       w_AXI_awready;   // write address ready
reg   [0:0]       q_AXI_awvalid;   // write address valid
reg   [0:0]       q_AXI_bready;    // (write) response ready  
wire  [1:0]       w_AXI_bresp;     // write response   
wire  [0:0]       w_AXI_bvalid;    // write response valid 
wire  [31:0]      w_AXI_rdata;     // read data
reg   [0:0]       q_AXI_rready;    // read ready
wire  [1:0]       w_AXI_rresp;     // read response
wire  [0:0]       w_AXI_rvalid;    // read valid
reg   [31:0]      q_AXI_wdata;     // write data
wire  [0:0]       w_AXI_wready;    // write ready
reg   [3:0]       q_AXI_wstrb;     // ??
reg   [0:0]       q_AXI_wvalid;     // write valid
//IRQ to AXI master
wire  IRQ;




/**
 * Instantiate the DUT.
*/
dule axi2spi_bridge(
//CLK
    .FCLK_CLK0(sys_clk),
//RST
    .RST_N(rst_n),
    
    
//AXI INTERFACE
    .AXI_araddr(q_AXI_araddr),    // read address address (data)
    .AXI_arprot(q_AXI_arprot),    // ???
    .AXI_arready(w_AXI_arready),   // read address ready
    .AXI_arvalid(q_AXI_arvalid),   // read address valid
    
    .AXI_awaddr(q_AXI_awaddr),    // write address address (channel data)
    .AXI_awprot(q_AXI_awprot),    // write address ??
    .AXI_awready(w_AXI_awready),   // write address ready
    .AXI_awvalid(q_AXI_awvalid),   // write address valid
    
    .AXI_bready(q_AXI_bready),    // (write) response ready  
    .AXI_bresp(w_AXI_bresp),     // write response   
    .AXI_bvalid(w_AXI_bvalid),    // write response valid 
    
    .AXI_rdata(w_AXI_rdata),     // read data
    .AXI_rready(q_AXI_rready),    // read ready
    .AXI_rresp(w_AXI_rresp),     // read response
    .AXI_rvalid(w_AXI_rvalid),    // read valid
    
    .AXI_wdata(q_AXI_wdata),     // write data
    .AXI_wready(w_AXI_wready),    // write ready
    .AXI_wstrb(q_AXI_wstrb),     // ??
    .AXI_wvalid(q_AXI_wvalid),     // write valid
//IRQ to AXI master
    .IRQ(w_IRQ),

//SPI interface
    .i_miso(miso),
    .o_mosi(mosi),
    .o_sclk(sclk)
    );

/**
 * Instantiate the SPI eeprom behaviorall.
*/
M95XXX eeprom_model_inst(
    .C(sclk),
    .D(mosi),
    .Q(miso),
    .S(spi_select),
    .W(1'b1),
    .HOLD(1'b1),
    .VCC(1'b1),
    .VSS(1'b0)
    );

/******************************************************************************
 * GENERATE STIMULUS
******************************************************************************/
enum integer {ADDR_READ, ADDR_WRITE, WRITE_DATA, READ_DATA, RESPONSE} AXI_CHANNEL;

/**
 * Set all register initial state to 0;
*/
initial begin
    spi_select      <= 0;
    sys_clk         <= 0;
    rst_n           <= 0;
    w_AXI_araddr    <= 0;    // read address address (data)
    w_AXI_arprot    <= 0;    // ???
    w_AXI_arvalid   <= 0;   // read address valid
    w_AXI_awaddr    <= 0;    // write address address (channel data)
    w_AXI_awprot    <= 0;    // write address ??
    w_AXI_awvalid   <= 0;   // write address valid
    w_AXI_bready    <= 0;    // (write) response ready 
    w_AXI_rready    <= 0;    // read ready
    w_AXI_wdata     <= 0;     // write data
    w_AXI_wstrb     <= 0;     // ??
    w_AXI_wvalid    <= 0;     // write valid
end

/**
 * Generate system clock for the AXI BUS
*/
always #5 begin
    sclk <= ~ sclk;
end

/**
 * Reset sequence: assert reset and release it.
*/
task reset_sequence;
    begin
        rst_n = 0;
        #20
        rst_n = 1;
        #20
    end
endtask

    
/**
 * axi_write_data() task writes 32 bits of data to the AXI2SPI bridge.
*/
task axi_write_data;
    input [31:0] data_to_write;
    input [31:0] target_address;
    begin
        _axi_channel_write_(target_address, ADDR_WRITE);
        _axi_channel_write_(data_to_write, ADDR_WRITE);
    end
endtask

   
/**
 * 
*/
task _axi_channel_write_;
    input [31:0] data_to_write;
    input AXI_CHANNEL channel_id;
    begin
    
    case (channel_id) begin
        ADDR_READ: begin
            _axi_channel_write2_(q_AXI_araddr, w_AXI_arready, q_AXI_arvalid)
        end
        ADDR_WRITE: begin
            _axi_channel_write2_(q_AXI_awaddr, w_AXI_awready, q_AXI_awvalid)
        end
        WRITE_DATA: begin
            _axi_channel_write2_(q_AXI_wdata, w_AXI_wready, q_AXI_wvalid)
        end
        READ_DATA: begin
            $display("ERROR: read write")
        end
        RESPONSE: begin
            $display("ERROR: response write")
        end
        
    endcase
    
    end
endtask


 
/**
 * 
 */
task _axi_channel_write2_;
    output  [31:0]      channel_data;    // read address address (data)
    // wire  [2:0]       q_AXI_arprot;    // ???
    input  [0:0]       channel_ready;   // read address ready
    output  [0:0]       channel_valid;   // read address valid
    begin
       
        @posedge (sys_clk)
        channel_data <= data_to_write;
        channel_valid <= 1'b1;
        if(channel_ready == 1'b0) begin
            forever @posedge (sys_clk) begin: wait_for_ready
                if(channel_ready == 1'b1)
                    disable wait_for_ready;
            end
        end
            
        channel_valid <= 1'b0;
    end
endtask

/**
 * Monitor the axi
*/
task axi_monitor_read;
    begin
        AXI_rready <= 1'b1;
        forever @posedge (sys_clk) begin: wait_for_valid
                if(AXI_rvalid == 1'b1) begin
                    
                    $display("Data got from AXI read: %h ", AXI_rdata);
                end
            end
    end
endtask

/******************************************************************************
 *
 ******************************************************************************/
initial begin
    #50
    // axi_write_data(...) TODO
end

    
    
    
endmodule