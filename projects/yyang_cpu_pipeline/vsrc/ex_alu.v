`include "defines.v"
module ex_alu(
    /* control signals */
    input   [`ALU_OP_BUS]       ex_alu_alu_op_i,
    input                       ex_alu_inst_slt_nu_i,
    input                       ex_alu_inst_slt_u_i,
    /* data signals*/
    input   [`DATA_BUS]         ex_alu_op1_i,
    input   [`DATA_BUS]         ex_alu_op2_i,

    output  [`DATA_BUS]         ex_alu_res_data_o
);

    /* rename */
    wire    [`ALU_OP_BUS]       alu_op;
    wire                        inst_slt_nu;
    wire                        inst_slt_u;

    wire    [`DATA_BUS]         op1;
    wire    [`DATA_BUS]         op2;

    wire    [`DATA_BUS]         alu_res_data;
    /* rename */

    wire                        alu_add;
    wire                        alu_sub;
    wire                        alu_xor;
    wire                        alu_or;
    wire                        alu_and;
    wire                        inst_sltxx;
    wire                        op_signed;

    wire    [`DATA_EXTEND_BUS]  extended_op1;
    wire    [`DATA_EXTEND_BUS]  extended_op2;
    wire    [`DATA_EXTEND_BUS]  alu_arh_res;
    wire    [`DATA_EXTEND_BUS]  alu_xor_res;
    wire    [`DATA_EXTEND_BUS]  alu_or_res;
    wire    [`DATA_EXTEND_BUS]  alu_and_res;
    wire    [`DATA_EXTEND_BUS]  alu_res_data_pre;

    /* rename */
    assign alu_op               =   ex_alu_alu_op_i;
    assign inst_slt_nu          =   ex_alu_inst_slt_nu_i;
    assign inst_slt_u           =   ex_alu_inst_slt_u_i;

    assign op1                  =   ex_alu_op1_i;
    assign op2                  =   ex_alu_op2_i;
    
    assign ex_alu_res_data_o    =   alu_res_data;
    /* rename */

    assign alu_add              =   alu_op == 3'b011;
    assign alu_sub              =   alu_op == 3'b100;
    assign alu_xor              =   alu_op == 3'b101;
    assign alu_or               =   alu_op == 3'b110;
    assign alu_and              =   alu_op == 3'b111;
    assign inst_sltxx           =   inst_slt_nu | inst_slt_u;
    assign op_signed            =   ~inst_slt_u;

    assign extended_op1         =   { op_signed & op1[63], op1 };
    assign extended_op2         =   { op_signed & op2[63], op2 };

    assign alu_arh_res          =   extended_op1 + ( alu_sub? ( ~extended_op2 + `DATA_EXTEND_SIZE'b1 ): extended_op2 );
    assign alu_xor_res          =   extended_op1 ^ extended_op2;
    assign alu_or_res           =   extended_op1 | extended_op2;
    assign alu_and_res          =   extended_op1 & extended_op2;

    assign alu_res_data_pre     =   `DATA_EXTEND_SIZE'b0
                                    | { `DATA_EXTEND_SIZE { alu_add | ( alu_sub & ~inst_sltxx ) } } & alu_arh_res
                                    | { `DATA_EXTEND_SIZE { alu_xor } } & alu_xor_res
                                    | { `DATA_EXTEND_SIZE { alu_or } } & alu_or_res
                                    | { `DATA_EXTEND_SIZE { alu_and } } & alu_and_res
                                    | { `DATA_EXTEND_SIZE { inst_sltxx  } } & { 64'b0, alu_arh_res[64]==1'b1 }; 
    assign alu_res_data         =   alu_res_data_pre[63:0];
endmodule