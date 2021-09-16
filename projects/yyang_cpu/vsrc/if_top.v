`include "defines.v"
module if_top (
    input                       clk,
    input                       rst,
    input                       branchjudge_ok,
    input                       inst_jump,
    input   [`INST_ADDR_BUS]    jump_addr,
    input   [`DATA_BUS]         imm_offset,
    output  [`INST_ADDR_BUS]    inst_addr
);
    wire [`INST_ADDR_BUS] nxt_inst_addr = inst_jump? jump_addr: ( inst_addr + ( branchjudge_ok? imm_offset: `INST_ADDR_SIZE'h4 )  );
    
    if_pc my_if_pc(
        .clk(clk),
        .rst(rst),
        .nxt_inst_addr( nxt_inst_addr ),
        .cur_inst_addr ( inst_addr )
    );

endmodule
