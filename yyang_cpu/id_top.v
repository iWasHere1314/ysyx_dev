`include "defines.v"
/* verilator lint_off UNUSED */

module id_top (
    input   [`INST_BUS]     inst,
    output  [`REG_INDEX]    rs1_index,
    output  [`REG_INDEX]    rs2_index,
    output                  rs1_ena,
    output                  rs2_ena,
    output  [`REG_INDEX]    rd_index,
    output                  rd_ena,
    /* 暂时不考虑ALU的操作码 */
    output  [`DATA_BUS]     imm_data,
    output                  alu_src
);
    /* 目前只考虑addi，故译码部分 */
    //wire insrt_is_arhlogi = inst[`OPCODE_BUS] == `INST_ARH_LOG_I;
    //wire insrt_is_arhlogi_addi = insrt_is_arhlogi && inst[`FUNCT3_BUS] == `INST_ARH_LOG_I_ADDI;
    
    assign rs1_index = inst[`RS1_BUS];
    assign rs2_index = inst[`RS2_BUS];
    assign rs1_ena = 1'b1;
    assign rs2_ena = 1'b0;
    
    assign rd_index = inst[`RD_BUS];
    assign rd_ena = 1'b1;

    wire [`I_IMM] imm_pre = inst[`I_IMM_BUS];
    assign imm_data = {{`DATA_BUS_SIZE-`I_IMM_SIZE{imm_pre[`I_IMM_SIZE-1]}}, imm_pre};
    assign alu_src = `ALU_SRC_IMM;
    
endmodule
