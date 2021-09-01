`include "defines.v"

module if_pc (
    input                       clk,
    input                       rst,
    input   [`INST_ADDR_BUS]    nxt_inst_addr,
    input                       inst_valid,
    output  [`INST_ADDR_BUS]    cur_inst_addr
);

    reg [`INST_ADDR_BUS] cur_inst_addr_r;

    always @( posedge clk ) begin
        if( rst == 1'b1 ) begin
            cur_inst_addr_r <= `PC_START - 64'h4;
        end
        else if( inst_valid )begin
            cur_inst_addr_r <= nxt_inst_addr;
        end
        else begin
            cur_inst_addr_r <= cur_inst_addr_r;
        end
    end

    assign cur_inst_addr    = cur_inst_addr_r;
endmodule
