module FIFO_module (data_in , wr_en , wclk , b_w_ptr , 
                    full  ,empty , rd_en , b_r_ptr ,  rclk  , 
                    data_out ); 

parameter data_width_p = 8   ; 
parameter mem_depth_p  = 256 ; 
parameter addr_size_p  = 8   ; 

input                           rclk   , wclk   ; 
input       [data_width_p-1:0]  data_in         ; 
input                           wr_en           ; 
input       [addr_size_p-1  :0] b_w_ptr         ;   // 8_bits 
input                           rd_en           ;   // 8_bits 
input       [addr_size_p-1  :0] b_r_ptr         ; 
input                           full            ;  
input                           empty           ;  

output  reg [data_width_p -1:0] data_out    ; 

// internal  : 

reg [data_width_p-1:0] mem [mem_depth_p-1:0] ; 

always @(posedge wclk ) begin
    if (wr_en && ~full) begin 
            mem[b_w_ptr] <= data_in ; 
    end 
end

always @(posedge rclk ) begin

        if(rd_en & ~empty) 
            data_out <= mem[b_r_ptr]  ; 
end

endmodule 