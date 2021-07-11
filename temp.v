module temp (
    input a,
    output b
);
    always @( posedge clk ) begin
        a <= a+1;
    end
    
endmodule