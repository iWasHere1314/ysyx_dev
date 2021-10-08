`include "defines.v"
module if_pc (
    input                       clk,
    input                       rst,

    /* control signals */
    input                       if_pc_inst_valid_i,
    input                       if_pc_dont_fetch_i,

    /* data_signals */
    input   [`INST_ADDR_BUS]    if_pc_nxt_inst_addr_i,
    output  [`INST_ADDR_BUS]    if_pc_cur_inst_addr_o
);

    reg [`INST_ADDR_BUS] cur_inst_addr_r;

    always @( posedge clk ) begin
        if( rst ) begin
            cur_inst_addr_r <= `PC_START;
        end
        else if( if_pc_inst_valid_i & ~if_pc_dont_fetch_i )begin
            cur_inst_addr_r <= if_pc_nxt_inst_addr_i;
        end
        else begin
            cur_inst_addr_r <= cur_inst_addr_r;
        end
    end

    assign if_pc_cur_inst_addr_o    = cur_inst_addr_r;
endmodule
