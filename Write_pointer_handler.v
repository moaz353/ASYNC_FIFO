// to handle w_ptr binary and gray ; 

// g_r_ptr_sync  >> binary to compare with b_w_ptr to assign full ; 
// compare b_w_ptr >> g_w_ptr to send it to 2ff_sync ;  done 
// increasing b_w_ptr when wr_en is high  = when execution write operation ; done 


module write_pointer_handler (wclk , wrst_n , wr_en , g_r_ptr_sync ,
                                full , b_w_ptr , g_w_ptr ) ; 

parameter addr_size_p = 8 ; 

input                      wclk        ; 
input                      wrst_n       ; 
input                      wr_en        ; 
input       [addr_size_p:0]  g_r_ptr_sync ;   // 9_bits 

output                     full         ; 
output reg  [addr_size_p:0]  b_w_ptr      ;   // 9_bits 
output reg  [addr_size_p:0]  g_w_ptr      ;   // 9_bits 

// internal signals 
reg [addr_size_p : 0] b_r_ptr_sync ;       // 9_bits
integer i;


// increasing b_w_ptr :
always @(posedge wclk or negedge wrst_n ) begin

    if(~wrst_n) 
        b_w_ptr <= 0 ; 
    else begin 
        if (wr_en && ~full) 
            b_w_ptr <= b_w_ptr + 1 ; 
    end

end

// b_w_ptr to g_w_ptr :   binary to gray 
always @(*) begin

        g_w_ptr[addr_size_p] = b_w_ptr[addr_size_p] ; 
        for (i = addr_size_p-1; i >= 0; i = i - 1) begin
            g_w_ptr[i] = b_w_ptr[i+1] ^ b_w_ptr[i];
        end

    end
// g_r_ptr_sync to b_r_ptr_sync to comparation :  gray to binary 

    always @(*) begin

        b_r_ptr_sync[addr_size_p] = g_r_ptr_sync[addr_size_p]; 
        for (i = addr_size_p-1; i >= 0; i = i - 1) begin
            b_r_ptr_sync[i] = b_r_ptr_sync[i+1] ^ g_r_ptr_sync[i];
        end

    end

assign full = b_r_ptr_sync[addr_size_p-1:0] == b_w_ptr[addr_size_p-1:0] & b_r_ptr_sync[addr_size_p] != b_w_ptr[addr_size_p] ; 
endmodule

