module Top_module  (wclk , rclk , wrst_n , rrst_n , wr_en , rd_en , data_in , full , empty , data_out) ; 

parameter data_width_p = 8   ; 
parameter mem_depth_p  = 256 ; 
parameter addr_size_p  = 8  ; 

input wclk   ; 
input rclk   ; 

input wrst_n ; 
input rrst_n ; 

input wr_en  ; 
input rd_en  ;

input [data_width_p-1:0] data_in ; 

output full ; 
output empty ; 

output [data_width_p-1:0] data_out ; 


// write_ptr 

wire [addr_size_p:0] b_w_ptr      ; 
wire [addr_size_p:0] g_w_ptr      ; 
wire [addr_size_p:0] g_w_ptr_sync ; 


// read_ptr 

wire [addr_size_p:0] b_r_ptr      ; 
wire [addr_size_p:0] g_r_ptr      ; 
wire [addr_size_p:0] g_r_ptr_sync ; 

// FIFO_block :
FIFO_module    #(.data_width_p(data_width_p) , 
                    .mem_depth_p(mem_depth_p),
                    .addr_size_p(addr_size_p) )
                
                FIFO   (.data_in  (data_in)  , 
                        .wr_en    (wr_en)    ,  
                        .wclk     (wclk)     , 
                        .full     (full)     , 
                        .b_w_ptr  (b_w_ptr[addr_size_p-1:0])  , 
                        .b_r_ptr  (b_r_ptr[addr_size_p-1:0])  ,  
                        .empty    (empty)    , 
                        .rclk     (rclk)     , 
                        .rd_en    (rd_en)    , 
                        .data_out (data_out)   );

// Write_pointer_handler_block :
write_pointer_handler   #(.addr_size_p(addr_size_p))
                    write_pointer 
                        ( .wclk       (wclk)         , 
                        .wrst_n       (wrst_n)       , 
                        .wr_en        (wr_en)        , 
                        .g_r_ptr_sync (g_r_ptr_sync) ,
                        .full         (full)         , 
                        .b_w_ptr      (b_w_ptr)      , 
                        .g_w_ptr      (g_w_ptr)        ); 

// Read_pointer_handler_block :
read_pointer_handler   #(.addr_size_p(addr_size_p))
                    read_pointer 
                        ( .rclk       (rclk)         , 
                        .rrst_n       (rrst_n)       , 
                        .rd_en        (rd_en)        , 
                        .g_w_ptr_sync (g_w_ptr_sync) ,
                        .empty        (empty)        ,
                        .b_r_ptr      (b_r_ptr)      , 
                        .g_r_ptr      (g_r_ptr)        ) ; 

//W_ptr_sync
twoFF_synchronizers  #(.addr_size_p(addr_size_p)) 
                    W_ptr_sync 
                        ( .in  (g_w_ptr)      , 
                        .clk   (rclk)         , 
                        .rst_n (rrst_n)       , 
                        .out   (g_w_ptr_sync)  );

// R_ptr_sync
twoFF_synchronizers  #(.addr_size_p(addr_size_p)) 
                    R_ptr_sync 
                        ( .in  (g_r_ptr)      , 
                        .clk   (wclk)         , 
                        .rst_n (wrst_n)       , 
                        .out   (g_r_ptr_sync)   ); 

endmodule 