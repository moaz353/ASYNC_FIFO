module twoFF_synchronizers ( in , clk , rst_n  , out );

parameter addr_size_p = 8 ; 

input                       clk , rst_n  ; 
input      [addr_size_p :0] in           ; 

output reg [addr_size_p:0] out           ; 

reg        [addr_size_p:0] in_reg        ; 

always @(posedge clk or negedge rst_n) begin

    if(~rst_n) begin 
        in_reg  <= 0 ; 
        out     <= 0 ; 
    end
    else begin  
        in_reg <= in     ;
        out    <= in_reg ; 
    end 

end

endmodule 
