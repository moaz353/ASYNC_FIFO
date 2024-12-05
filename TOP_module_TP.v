`timescale 1ns/1ps

module Top_module_tb;

    parameter DATA_WIDTH_P = 8;
    parameter MEM_DEPTH_P  = 256;
    parameter ADDR_SIZE_P  = 8;

    reg wclk, rclk, wrst_n, rrst_n;

    reg wr_en, rd_en;

    reg [DATA_WIDTH_P-1:0] data_in;
    wire [DATA_WIDTH_P-1:0] data_out;

    wire full, empty;

    // DUT instantiation
    Top_module #(
        .data_width_p(DATA_WIDTH_P),
        .mem_depth_p(MEM_DEPTH_P),
        .addr_size_p(ADDR_SIZE_P)
    ) DUT (
        .wclk(wclk)        ,
        .rclk(rclk)        ,
        .wrst_n(wrst_n)    ,
        .rrst_n(rrst_n)    ,
        .wr_en(wr_en)      ,
        .rd_en(rd_en)      ,
        .data_in(data_in)  ,
        .full(full)        ,
        .empty(empty)      ,
        .data_out(data_out)
                                );

    // Clock generation
    initial begin
        wclk = 0;
        forever #10 wclk = ~wclk; // Write clock
    end

    initial begin
        rclk = 0;
        forever #7 rclk = ~rclk; // Read clock
    end

    // Testbench stimuli
    initial begin
        // Initialize signals
        wrst_n = 0;
        rrst_n = 0;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;
        $readmemb ("mem.dat" , DUT.FIFO.mem) ;

        // Apply reset
        #20;
        wrst_n = 1;
        rrst_n = 1;

        // Write operations
        repeat (20) begin
            @(negedge wclk);
            wr_en = 1;
            data_in =$random ;  // Increment data
        end
        @(negedge wclk);
        wr_en = 0; // Stop writing

        // Allow some time
        #50;

        // Read operations
        repeat (20) begin
            @(negedge rclk);
            rd_en = 1;
        end
        @(negedge rclk);
        rd_en = 0; // Stop reading

        // Finish simulation
        #100;
        $stop ; 
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t | wr_en=%b | rd_en=%b | data_in=%h | data_out=%h | full=%b | empty=%b",
                $time, wr_en, rd_en, data_in, data_out, full, empty);
    end

endmodule
