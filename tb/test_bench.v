
`timescale 1ns/1ns

/******************************************************************************
 *
******************************************************************************/


module simulation_top ();

/**
 * Signal definitions to connect the DUT.
*/
wire sclk, mosi, miso;
reg spi_select;

reg sys_clk, rst_n;
reg   [31:0]      q_AXI_araddr;    // read address address (data)
reg   [2:0]       q_AXI_arprot;    // ???
wire              w_AXI_arready;   // read address ready
reg               q_AXI_arvalid;   // read address valid
reg   [31:0]      q_AXI_awaddr;    // write address address (channel data)
reg   [2:0]       q_AXI_awprot;    // write address ??
wire              w_AXI_awready;   // write address ready
reg               q_AXI_awvalid;   // write address valid
reg               q_AXI_bready;    // (write) response ready  
wire  [1:0]       w_AXI_bresp;     // write response   
wire              w_AXI_bvalid;    // write response valid 
wire  [31:0]      w_AXI_rdata;     // read data
reg               q_AXI_rready;    // read ready
wire  [1:0]       w_AXI_rresp;     // read response
wire              w_AXI_rvalid;    // read valid
reg   [31:0]      q_AXI_wdata;     // write data
wire              w_AXI_wready;    // write ready
reg   [3:0]       q_AXI_wstrb;     // ??
reg               q_AXI_wvalid;     // write valid
//IRQ to AXI master
wire  IRQ;




/**
 * Instantiate the DUT.
*/
axi2spi_bridge axi_spi_DUT(
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
 * Macros for eeprom:
*/
M95XXX_Macro_mux M95XXX_Macro_mux_inst ();

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

// AXI is a 32 bits width bus. We must multiply addresses by 4.
`define ADDR_CONTROL_REG    32'h0*4
`define ADDR_STATUS_REG     32'h1*4
`define ADDR_DATA_REG       32'h2*4 

// enum  integer{ADDR_READ, ADDR_WRITE, WRITE_DATA, READ_DATA, RESPONSE} AXI_CHANNEL;

/**
 * Set all register initial state to 0;
*/
initial begin
    spi_select      = 0;
    sys_clk         = 0;
    rst_n           = 0;
    q_AXI_araddr    = 0;    // read address address (data)
    q_AXI_arprot    = 0;    // ???
    q_AXI_arvalid   = 0;   // read address valid
    q_AXI_awaddr    = 0;    // write address address (channel data)
    q_AXI_awprot    = 0;    // write address ??
    q_AXI_awvalid   = 0;   // write address valid
    q_AXI_bready    = 0;    // (write) response ready 
    q_AXI_rready    = 0;    // read ready
    q_AXI_wdata     = 0;     // write data
    q_AXI_wstrb     = 0;     // ??
    q_AXI_wvalid    = 0;     // write valid
end

initial $timeformat(-9, 0, " ns", 8);

/**
 * Generate system clock for the AXI BUS
*/
always #5 begin
    sys_clk <= ~ sys_clk;
end

/**
 * Reset sequence: assert reset and release it.
*/
task reset_sequence;
    begin
        rst_n = 0;
        spi_select = 1;
        #20
        rst_n = 1;
        #20 begin end
    end
endtask

    
/**
 * axi_read_data() task read 32 bits of data from the AXI2SPI bridge.
*/
task axi_read_data;
    input [31:0] target_address;
    begin
        fork 
        
            begin
                $display("axi_read_data:: ADDR_WRITE. q_AXI_araddr, target_address %h  , w_AXI_arready, q_AXI_arvalid  ", target_address);
                
                
                @(posedge sys_clk)
                q_AXI_araddr <= target_address;
                q_AXI_arvalid <= 1'b1;
                if(w_AXI_arready !== 1'b1) begin: wait_for_ready_ADW
                    forever @(posedge sys_clk) begin
                        if(w_AXI_arready == 1'b1)
                            disable wait_for_ready_ADW;
                    end
                end
                    
                q_AXI_arvalid <= 1'b0;
            end
            begin
                // $display("axi_read_data:: WRITE_DATA. qq_AXI_wdata, data_to_write %h  , w_AXI_wready, q_AXI_wvalid  ", data_to_write);
                
                // @(posedge sys_clk)
                // q_AXI_wdata <= data_to_write;
                // q_AXI_wvalid <= 1'b1;
                // if(w_AXI_wready !== 1'b1) begin: wait_for_ready_WD
                    // forever @(posedge sys_clk) begin
                        // if(w_AXI_wready == 1'b1)
                            // disable wait_for_ready_WD;
                    // end
                // end
                    
                // q_AXI_wvalid <= 1'b0;
            end
        join;
        $display("END ");
    end
endtask


   
/**
 * axi_write_data() task writes 32 bits of data to the AXI2SPI bridge.
*/
task axi_write_data;
    input [31:0] data_to_write;
    input [31:0] target_address;
    begin
        fork 
        
            begin
                $display("axi_write_data:: ADDR_WRITE. q_AXI_awaddr, target_address %h  , w_AXI_awready, q_AXI_awvalid  ", target_address);
                
                
                @(posedge sys_clk)
                q_AXI_awaddr <= target_address;
                q_AXI_awvalid <= 1'b1;
                if(w_AXI_awready !== 1'b1) begin: wait_for_ready_ADW
                    forever @(posedge sys_clk) begin
                        if(w_AXI_awready == 1'b1)
                            disable wait_for_ready_ADW;
                    end
                end
                    
                q_AXI_awvalid <= 1'b0;
            end
            begin
                $display("axi_write_data:: WRITE_DATA. qq_AXI_wdata, data_to_write %h  , w_AXI_wready, q_AXI_wvalid  ", data_to_write);
                
                @(posedge sys_clk)
                q_AXI_wdata <= data_to_write;
                q_AXI_wvalid <= 1'b1;
                if(w_AXI_wready !== 1'b1) begin: wait_for_ready_WD
                    forever @(posedge sys_clk) begin
                        if(w_AXI_wready == 1'b1)
                            disable wait_for_ready_WD;
                    end
                end
                    
                q_AXI_wvalid <= 1'b0;
            end
        join;
       // 写完以后处理bready-bvalid握手
        @(posedge sys_clk);
        q_AXI_bready <= 1'b1;
        wait(w_AXI_bvalid == 1'b1);
        @(posedge sys_clk);
        q_AXI_bready <= 1'b0;
        
        $display("END ");
    end
endtask

   
/**
 * 

task _axi_channel_write_;
    input [31:0] data_to_write;
    input integer channel_id;
    begin
       
    case (channel_id)
        ADDR_READ: begin
            $display("_axi_channel_write_:: ADDR_READ. q_AXI_araddr,    data_to_write: %h   w_AXI_arready   q_AXI_arvalid   ", data_to_write);
            
            
            @(posedge sys_clk)
            q_AXI_araddr <= data_to_write;
            q_AXI_arvalid <= 1'b1;
            if(w_AXI_arready !== 1'b1) begin
                forever @(posedge sys_clk) begin: wait_for_ready
                    if(w_AXI_arready == 1'b1)
                        disable wait_for_ready;
                end
            end
                
            q_AXI_arvalid <= 1'b0;
        
            
            // _axi_channel_write2_(q_AXI_araddr, data_to_write, w_AXI_arready, q_AXI_arvalid);
        end
        ADDR_WRITE: begin
            $display("_axi_channel_write_:: ADDR_WRITE. q_AXI_awaddr, data_to_write %h  , w_AXI_awready, q_AXI_awvalid  ", data_to_write);
            
            
            @(posedge sys_clk)
            q_AXI_awaddr <= data_to_write;
            q_AXI_awvalid <= 1'b1;
            if(w_AXI_awready !== 1'b1) begin
                forever @(posedge sys_clk) begin: wait_for_ready_ADW
                    if(w_AXI_awready == 1'b1)
                        disable wait_for_ready_ADW;
                end
            end
                
            q_AXI_awvalid <= 1'b0;
        
            
            // _axi_channel_write2_(q_AXI_awaddr, data_to_write, w_AXI_awready, q_AXI_awvalid);
        end
        WRITE_DATA: begin
            $display("_axi_channel_write_:: WRITE_DATA. qq_AXI_wdata, data_to_write %h  , w_AXI_wready, q_AXI_wvalid  ", data_to_write);
            
            @(posedge sys_clk)
            q_AXI_wdata <= data_to_write;
            q_AXI_wvalid <= 1'b1;
            if(w_AXI_wready !== 1'b1) begin
                forever @(posedge sys_clk) begin: wait_for_ready_WD
                    if(w_AXI_wready == 1'b1)
                        disable wait_for_ready_WD;
                end
            end
                
            q_AXI_wvalid <= 1'b0;
        
            
            //_axi_channel_write2_(q_AXI_wdata, data_to_write, w_AXI_wready, q_AXI_wvalid);
        end
        READ_DATA: begin
            $display("ERROR: read write");
        end
        RESPONSE: begin
            $display("ERROR: response write");
        end
        
    endcase
    
    end
endtask

*/
 
/**
 * 
 */
task _axi_channel_write2_;
    output  [31:0]  channel_data;    // read address address (data)
    input   [31:0]  data_to_write;
    input           channel_ready;   // read address ready
    output          channel_valid;   // read address valid
    
    begin
       
        @(posedge sys_clk)
        channel_data <= data_to_write;
        $display("%t _axi_channel_write2_:: ENTER data_to_write: %h", $time, data_to_write);
        $display("_axi_channel_write2_:: ENTER channel_data: %h", channel_data);
        channel_valid <= 1'b1;
        if(channel_ready !== 1'b1) begin
            forever @(posedge sys_clk) begin: wait_for_ready
                if(channel_ready == 1'b1)
                    disable wait_for_ready;
            end
        end
            
        channel_valid <= 1'b0;
        
        #0ns
        $display("_axi_channel_write2_:: LEAVE");
    end
endtask

/**
 * Monitor the axi
*/
task axi_monitor_read;
    begin
    
        $display("axi_monitor_read:: ENTER");
        fork 
            forever begin
                @(posedge sys_clk);
                if (w_AXI_rvalid) begin
                q_AXI_rready <= 1'b1;
                end else begin
                q_AXI_rready <= 1'b0;
                end
            end
        
            forever @ (posedge sys_clk) begin: wait_for_valid
                if(w_AXI_rvalid == 1'b1) begin
                    
                    $display("Data got from AXI read: %h ", w_AXI_rdata);
                end
            end
        join;
        $display("axi_monitor_read:: LEAVE");
    end
endtask

task eeprom_write_enable;
    begin
        $display("eeprom_write_enable:: ENTER");
    
        #500ns
        
        spi_select <= '0;
        #500ns
        // Write command of EEPROM 
        axi_write_data(
            .target_address(`ADDR_DATA_REG),
            .data_to_write(8'h06)   // Write
            );
    
        #3us
        spi_select <= '1;
        #10us            
        $display("eeprom_write_enable:: LEAVE");
    end
endtask
    
    

/**
 * write_eeprom
*/
task write_eeprom;
    input [7:0] eeprom_address;
    input [7:0] eeprom_datas[];
    input integer number_of_datas;

    begin
        $display("write_eeprom:: ENTER");
        
        eeprom_write_enable();
        
        spi_select <= '0;
        
        #500ns
        // Write command of EEPROM 
        axi_write_data(
            .target_address(`ADDR_DATA_REG),
            .data_to_write(8'h02)   // Write
            );
            
        // wait(w_IRQ == 1);
        
        #3us
        
        // Write address of EEPROM 
        axi_write_data(
            .target_address(`ADDR_DATA_REG),
            .data_to_write(eeprom_address)   // 
            );
            
            
        for (int i = 0; i< number_of_datas; i++) begin
            
            #3us
            
            // data of eeprom
            axi_write_data(
                .target_address(`ADDR_DATA_REG),
                .data_to_write(eeprom_datas[i])   // 
                );
        end
            
        #3us
        spi_select <= '1;
        $display("write_eeprom :: Wait for eeprom write time...");
        #10us            
        $display("write_eeprom:: LEAVE");
    end
endtask

/**
 * read_eeprom
*/
task read_eeprom;
    input [7:0] eeprom_address;
    input integer count_of_bytes;

    begin
        
        
        spi_select <= '0;
        
        #500ns
        
        // send REad command of EEPROM 
        axi_write_data(
            .target_address(`ADDR_DATA_REG),
            .data_to_write(8'h03)   // read
            );
            
        // wait(w_IRQ == 1);
        
        #3us
        
        // send REad address of EEPROM 
        axi_write_data(
            .target_address(`ADDR_DATA_REG),
            .data_to_write(eeprom_address)   // 
            );
            
        #3us
            
            
        for (int i = 0; i< count_of_bytes; i++) begin
            
            // send dummy 0x00 to read data
            axi_write_data(
                .target_address(`ADDR_DATA_REG),
                .data_to_write(0)   // 
                );
                
            
            #3us    
            // send dummy 0x00 to read data
            axi_read_data(
                .target_address(`ADDR_DATA_REG)
                );
                
                
        end
            
            
        #3us
            
        spi_select <= '1;
        
        #500ns begin end
        
    end
endtask

/**
 * init_spi_periperal
*/
task init_spi_periperal;
    begin
        $display("init_spi_periperal:: ENTER");
        axi_write_data(
            .target_address(`ADDR_CONTROL_REG),
            .data_to_write(8'b1101_0010)   // SPIE SPE DORD MSTR CPOL CPHA SPR1 SPR0
            );
        $display("init_spi_periperal:: LEAVE");
    end
endtask

/******************************************************************************
 *
 ******************************************************************************/
initial begin
    #50ns
    
    reset_sequence();
    
    #50ns
    
    init_spi_periperal();
    
    #50ns
    
    fork
        axi_monitor_read();
    join_none;
    
    #50ns
    
    write_eeprom(4, {8'haa, 8'hff, 8'h00, 8'h55, 8'hc3, 8'h3c}, 6);
    
    #50ns
    
    read_eeprom(4, 6);
    
    #50ns
    begin end
end

    
    
    
endmodule
