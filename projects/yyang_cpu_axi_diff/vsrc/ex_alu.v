`include "defines.v"
module ex_alu (
    /* control signals */
    
    // compare
    input   [`COMP_TYPE_BUS]    comp_type, 
    
    // alu
    input                       alu_src_pc,
    input                       alu_src_imm,
    input   [`ALU_OP_BUS]       alu_op,
    
    /* data */
    input   [`INST_ADDR_BUS]    pc,
    input   [`DATA_BUS]         rs1_data,
    input   [`DATA_BUS]         rs2_data,
    input   [`DATA_BUS]         imm_data,

    /* output */
    output  [`DATA_EXTEND_BUS]  alu_res_data
);

    wire alu_add;
    wire alu_sub;
    wire alu_xor;
    wire alu_or;
    wire alu_and;
    wire comp_signed;

    wire [`DATA_BUS]        alu_op1_pre;
    wire [`DATA_BUS]        alu_op2_pre;
    wire [`DATA_EXTEND_BUS] alu_op1;
    wire [`DATA_EXTEND_BUS] alu_op2;
    wire [`DATA_EXTEND_BUS] alu_arh_res;
    wire [`DATA_EXTEND_BUS] alu_xor_res;
    wire [`DATA_EXTEND_BUS] alu_or_res;
    wire [`DATA_EXTEND_BUS] alu_and_res;
    
    assign alu_add      =   alu_op == 3'b011;
    assign alu_sub      =   alu_op == 3'b100;
    assign alu_xor      =   alu_op == 3'b101;
    assign alu_or       =   alu_op == 3'b110;
    assign alu_and      =   alu_op == 3'b111;
    assign comp_signed  =   comp_type[2] & comp_type[0]; // ( comp_type[2] == 1'b1 ) && ( comp_type[0] == 1'b1 );

    assign alu_op1_pre  =   ( alu_src_pc  == 1'b1 )? rs1_data: pc;
    assign alu_op2_pre  =   ( alu_src_imm == 1'b0 )? rs2_data: imm_data;
    assign alu_op1      =   { comp_signed & alu_op1_pre[63], alu_op1_pre };
    assign alu_op2      =   { comp_signed & alu_op2_pre[63], alu_op2_pre };

    assign alu_arh_res  =   alu_op1 + ( alu_sub? ( ~alu_op2 + `DATA_EXTEND_SIZE'b1 ): alu_op2 );
    assign alu_xor_res  =   alu_op1 ^ alu_op2;
    assign alu_or_res   =   alu_op1 | alu_op2;
    assign alu_and_res  =   alu_op1 & alu_op2;

    assign alu_res_data =   `DATA_EXTEND_SIZE'b0
                            | { `DATA_EXTEND_SIZE { alu_add | alu_sub } } & alu_arh_res
                            | { `DATA_EXTEND_SIZE { alu_xor } } & alu_xor_res
                            | { `DATA_EXTEND_SIZE { alu_or } } & alu_or_res
                            | { `DATA_EXTEND_SIZE { alu_and } } & alu_and_res;
endmodule