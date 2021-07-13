`include "defines.v"
module ex_top (
    input                alu_src,
    input   [`DATA_BUS]  oprand1,
    input   [`DATA_BUS]  oprand2,
    input   [`DATA_BUS]  imm_data,
    output  [`DATA_BUS]  rd_data
);
    wire [`DATA_BUS] op1 = oprand1;
    wire [`DATA_BUS] op2 = alu_src == `ALU_SRC_IMM ? imm_data: oprand2;
    assign  rd_data = op1 + op2;

endmodule
