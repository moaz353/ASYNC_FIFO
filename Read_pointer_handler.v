// to handle r_ptr binary and gray ; 

// g_w_ptr_sync  >> binary to compare with b_r_ptr to assign empty ; 
// compare b_r_ptr >> g_r_ptr to send it to 2ff_sync ;  done 
// increasing b_r_ptr when rd_en is high  = when execution read operation ; done 


module read_pointer_handler (rclk , rrst_n , rd_en , g_w_ptr_sync , empty , b_r_ptr , g_r_ptr ) ; 

parameter addr_size_p = 8 ; 

input                      rclk        ; 
input                      rrst_n       ; 
input                      rd_en        ; 
input       [addr_size_p:0]  g_w_ptr_sync ;   // 9_bits 

output                     empty         ; 
output reg  [addr_size_p:0]  b_r_ptr      ;   // 9_bits 
output reg  [addr_size_p:0]  g_r_ptr      ;   // 9_bits 

// internal signals 
reg [addr_size_p : 0] b_w_ptr_sync ;       // 9_bits
integer i;

// increasing b_r_ptr :
always @(posedge rclk or negedge rrst_n ) begin

    if(~rrst_n) 
        b_r_ptr <= 0 ; 
    else begin 
        if (rd_en && ~empty) 
            b_r_ptr <= b_r_ptr + 1 ; 
    end

end

// b_r_ptr to g_r_ptr :   binary to gray 
always @(*) begin

        g_r_ptr[addr_size_p] = b_r_ptr[addr_size_p] ; 
        for (i = addr_size_p-1; i >= 0; i = i - 1) begin
            g_r_ptr[i] = b_r_ptr[i+1] ^ b_r_ptr[i];
        end

    end
// g_w_ptr_sync to b_w_ptr_sync to comparation :  gray to binary 

    always @(*) begin

        b_w_ptr_sync[addr_size_p] = g_w_ptr_sync[addr_size_p]; 
        for (i = addr_size_p-1; i >= 0; i = i - 1) begin
            b_w_ptr_sync[i] = b_w_ptr_sync[i+1] ^ g_w_ptr_sync[i];
        end

    end

assign empty = b_w_ptr_sync == b_r_ptr ; 
endmodule

