
module binary_to_gray #(
    parameter WIDTH = 4  // Default number of bits
)(
    input  [WIDTH-1:0] binary,
    output [WIDTH-1:0] gray
);
    integer i;

    // Gray calculation
    always @(*) begin
        gray[WIDTH-1] = binary[WIDTH-1];  // MSB is the same
        for (i = WIDTH-2; i >= 0; i = i - 1) begin
            gray[i] = binary[i+1] ^ binary[i];
        end
    end
endmodule
