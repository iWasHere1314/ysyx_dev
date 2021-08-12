`include "defines.v"

module if_pc (
    input                       clk,
    input                       rst,
    input   [`INST_ADDR_BUS]    nxt_inst_addr,
    output  [`INST_ADDR_BUS]    cur_inst_addr 
);

    reg [`INST_ADDR_BUS] cur_inst_addr_r;
    always @( posedge clk ) begin
        if( rst == 1'b1 ) begin
            cur_inst_addr_r <= `INST_ADDR_SIZE'b0;
        end
        else begin
            cur_inst_addr_r <= nxt_inst_addr;
        end
    end

    assign cur_inst_addr = cur_inst_addr_r;
    
endmodule
