`include "defines.v"
module ex_core(
    /* control signals */
    input   [`ALU_OP_BUS]       ex_core_alu_op_i,
    input                       ex_core_inst_slt_nu_i,
    input                       ex_core_inst_slt_u_i,
    input   [`SHIFT_TYPE_BUS]   ex_core_shift_type_i,
    input                       ex_core_shift_num_src,
    input                       ex_core_inst_word_i,
    input                       ex_core_alu_src_pc_i,
    input                       ex_core_alu_src_imm_i,
    input                       ex_core_inst_shift_i,
    /* data signals*/
    input   [`INST_ADDR_BUS]    ex_core_inst_addr_i,
    input   [`DATA_BUS]         ex_core_rs1_data_i,
    input   [`DATA_BUS]         ex_core_rs2_data_i,
    input   [`DATA_BUS]         ex_core_imm_data_i,

    output  [`DATA_BUS]         ex_core_res_data_o
);
    wire    [`DATA_BUS]         ex_alu_op1_i;
    wire    [`DATA_BUS]         ex_alu_op2_i;
    wire    [`DATA_BUS]         ex_alu_res_data_o;
    wire    [`DATA_BUS]         ex_shifter_shift_num_i;
    wire    [`DATA_BUS]         ex_shifter_res_data_o;
    wire    [`DATA_BUS]         ex_wordgen_rs1_data_o;
    wire    [`DATA_BUS]         ex_wordgen_rs2_data_o;
    wire    [`DATA_BUS]         ex_wordgen_res_pre_data_o;

    wire    [`DATA_BUS]         rs1_data;
    wire    [`DATA_BUS]         rs2_data;
    wire    [`DATA_BUS]         res_pre;

    assign { rs1_data, rs2_data }   =   ex_core_inst_word_i? { ex_wordgen_rs1_data_o, ex_wordgen_rs2_data_o }:
                                            { ex_core_rs1_data_i, ex_core_rs2_data_i };
    assign ex_alu_op1_i          =   ( ex_core_alu_src_pc_i == 1'b0 ) ? ex_core_inst_addr_i: rs1_data;
    assign ex_alu_op2_i             =   ex_core_alu_src_imm_i? ex_core_imm_data_i: rs2_data;
    assign ex_shifter_shift_num_i   =   ex_core_shift_num_src? ex_core_imm_data_i: ex_core_rs2_data_i;

    assign res_pre                  =   ex_core_inst_shift_i? ex_shifter_res_data_o: ex_alu_res_data_o;
    assign ex_core_res_data_o       =   ex_core_inst_word_i? ex_wordgen_res_pre_data_o: res_pre;

    ex_alu my_ex_alu(
        /* control signals */
        .ex_alu_alu_op_i( ex_core_alu_op_i ),
        .ex_alu_inst_slt_nu_i( ex_core_inst_slt_nu_i ),
        .ex_alu_inst_slt_u_i( ex_core_inst_slt_u_i ),
        /* data signals*/
        .ex_alu_op1_i( ex_alu_op1_i ),
        .ex_alu_op2_i( ex_alu_op2_i ),

        .ex_alu_res_data_o( ex_alu_res_data_o )
    );

    ex_shifter my_ex_shifter(
        /* control signals */
        .ex_shifter_shift_type_i( ex_core_shift_type_i ),

        /* data signals*/
        .ex_shifter_shifted_data_i( rs1_data ),
        .ex_shifter_shift_num_i( ex_shifter_shift_num_i ),

        .ex_shifter_res_data_o( ex_shifter_res_data_o )
    );

    ex_wordgen rs1_ex_wordgen(
        /* control signals */
        .ex_wordgen_inst_word_i( ex_core_inst_word_i ), 

        /* data */
        .ex_wordgen_wordgen_src_data_i( ex_core_rs1_data_i ),

        /* output */
        .ex_wordgen_res_data_o( ex_wordgen_rs1_data_o )
    );

    ex_wordgen rs2_ex_wordgen(
        /* control signals */
        .ex_wordgen_inst_word_i( ex_core_inst_word_i ), 

        /* data */
        .ex_wordgen_wordgen_src_data_i( ex_core_rs2_data_i ),

        /* output */
        .ex_wordgen_res_data_o( ex_wordgen_rs2_data_o )
    );

    ex_wordgen res_pre_ex_wordgen(
        /* control signals */
        .ex_wordgen_inst_word_i( ex_core_inst_word_i ), 

        /* data */
        .ex_wordgen_wordgen_src_data_i( res_pre ),

        /* output */
        .ex_wordgen_res_data_o( ex_wordgen_res_pre_data_o)
    );
    
endmodule