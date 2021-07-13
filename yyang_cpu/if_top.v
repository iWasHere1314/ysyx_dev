`include "defines.v"
module if_top (
    input                   clk,
    input                   rst,
    output  [`INST_ADDR]    inst_addr,
    output                  inst_ena
);
    wire [`INST_ADDR] nxt_inst_addr = inst_addr + `INST_ADDR_SIZE'h4;
    
    if_pc my_if_pc(
        .clk(clk),
        .rst(rst),
        .nxt_inst_addr( nxt_inst_addr ),
        .cur_inst_addr ( inst_addr )
    );

    assign inst_ena = 1'b1;
endmodule
