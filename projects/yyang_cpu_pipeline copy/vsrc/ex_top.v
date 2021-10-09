`include "defines.v"
module ex_top(
    input                       clk,
    input                       rst,

    /* control signals */

    input                       ex_top_id2ex_rs1_en_i,
    input                       ex_top_id2ex_rs2_en_i,
    input                       ex_top_ex2mem_rd_en_i,
    input                       ex_top_mem2wb_rd_en_i,

    input                       ex_top_inst_word_i,
    input                       ex_top_inst_slt_nu_i,
    input                       ex_top_inst_slt_u_i,
    input                       ex_top_inst_shift_i,
    input                       ex_top_alu_src_pc_i,
    input                       ex_top_alu_src_imm_i,
    input                       ex_top_shift_num_src_i,
    input   [`SHIFT_TYPE_BUS]   ex_top_shift_type_i,
    input                       ex_top_inst_arth_lgc_i,
    input                       ex_top_inst_auipc_i,
    input   [`ALU_OP_BUS]       ex_top_alu_op_i,

    input                       ex_top_mem_read_i,
    input                       ex_top_mem_write_i,
    input   [`REG_INDEX_BUS]    ex_top_id2ex_rs1_index_i,
    input   [`REG_INDEX_BUS]    ex_top_id2ex_rs2_index_i,
    input   [`REG_INDEX_BUS]    ex_top_ex2mem_rd_index_i,
    input   [`REG_INDEX_BUS]    ex_top_mem2wb_rd_index_i,


    output                      ex_top_ex_rs1_src_ex2mem_o,
    output                      ex_top_ex_rs2_src_ex2mem_o,

    /* data signals */
    input   [`DATA_BUS]         ex_top_imm_data_i,
    input   [`REG_BUS]          ex_top_id2ex_rs1_data_i,
    input   [`REG_BUS]          ex_top_id2ex_rs2_data_i,
    input   [`REG_BUS]          ex_top_id2ex_rd_data_i,
    input   [`REG_BUS]          ex_top_ex2mem_rd_data_i,
    input   [`REG_BUS]          ex_top_mem2wb_rd_data_i,
    input   [`INST_ADDR_BUS]    ex_top_inst_addr_i,

    output  [`DATA_BUS]         ex_top_rd_data_o
);
    wire                        ex_forward_ex_rs1_src_id2ex_o;
    wire                        ex_forward_ex_rs1_src_ex2mem_o;
    wire                        ex_forward_ex_rs1_src_mem2wb_o;
    wire                        ex_forward_ex_rs2_src_id2ex_o;
    wire                        ex_forward_ex_rs2_src_ex2mem_o;
    wire                        ex_forward_ex_rs2_src_mem2wb_o;
    wire    [`DATA_BUS]         ex_core_res_data_o;
    wire    [`DATA_BUS]         rs1_data;
    wire    [`DATA_BUS]         rs2_data;

    assign rs1_data                     =     ( { 64 { ex_forward_ex_rs1_src_id2ex_o } } & ex_top_id2ex_rs1_data_i ) 
                                            | ( { 64 { ex_forward_ex_rs1_src_ex2mem_o } } & ex_top_ex2mem_rd_data_i)
                                            | ( { 64 { ex_forward_ex_rs1_src_mem2wb_o } } & ex_top_mem2wb_rd_data_i );

    assign rs2_data                     =     ( { 64 { ex_forward_ex_rs2_src_id2ex_o } } & ex_top_id2ex_rs2_data_i ) 
                                            | ( { 64 { ex_forward_ex_rs2_src_ex2mem_o } } & ex_top_ex2mem_rd_data_i)
                                            | ( { 64 { ex_forward_ex_rs2_src_mem2wb_o } } & ex_top_mem2wb_rd_data_i );

    assign ex_top_rd_data_o             =   ( ex_top_inst_arth_lgc_i | ex_top_inst_auipc_i | ex_top_mem_read_i | ex_top_mem_write_i ) ?
                                            ex_core_res_data_o: ex_top_id2ex_rd_data_i; 
    
    assign ex_top_ex_rs1_src_ex2mem_o   =   ex_forward_ex_rs1_src_ex2mem_o;
    assign ex_top_ex_rs2_src_ex2mem_o   =   ex_forward_ex_rs2_src_ex2mem_o;

    ex_core my_ex_core(
        /* control signals */
        .ex_core_alu_op_i( ex_top_alu_op_i ),
        .ex_core_inst_slt_nu_i( ex_top_inst_slt_nu_i ),
        .ex_core_inst_slt_u_i( ex_top_inst_slt_u_i ),
        .ex_core_shift_type_i( ex_top_shift_type_i ),
        .ex_core_shift_num_src( ex_top_shift_num_src_i ),
        .ex_core_inst_word_i( ex_top_inst_word_i ),
        .ex_core_alu_src_pc_i( ex_top_alu_src_pc_i ),
        .ex_core_alu_src_imm_i( ex_top_alu_src_imm_i ),
        .ex_core_inst_shift_i( ex_top_inst_shift_i ),
        /* data signals*/
        .ex_core_inst_addr_i( ex_top_inst_addr_i ),
        .ex_core_rs1_data_i( rs1_data ),
        .ex_core_rs2_data_i( rs2_data ),
        .ex_core_imm_data_i( ex_top_imm_data_i ),

        .ex_core_res_data_o( ex_core_res_data_o )
    );
    
    ex_forward my_ex_forward(
        .ex_forward_id2ex_rs1_en_i( ex_top_id2ex_rs1_en_i ),
        .ex_forward_id2ex_rs2_en_i( ex_top_id2ex_rs2_en_i ),
        .ex_forward_ex2mem_rd_en_i( ex_top_ex2mem_rd_en_i ),
        .ex_forward_mem2wb_rd_en_i( ex_top_mem2wb_rd_en_i ),
        .ex_forward_id2ex_rs1_index_i( ex_top_id2ex_rs1_index_i ),
        .ex_forward_id2ex_rs2_index_i( ex_top_id2ex_rs2_index_i ),
        .ex_forward_ex2mem_rd_index_i( ex_top_ex2mem_rd_index_i ),
        .ex_forward_mem2wb_rd_index_i( ex_top_mem2wb_rd_index_i ),

        .ex_forward_ex_rs1_src_id2ex_o( ex_forward_ex_rs1_src_id2ex_o ),
        .ex_forward_ex_rs1_src_ex2mem_o( ex_forward_ex_rs1_src_ex2mem_o ),
        .ex_forward_ex_rs1_src_mem2wb_o( ex_forward_ex_rs1_src_mem2wb_o ),
        .ex_forward_ex_rs2_src_id2ex_o( ex_forward_ex_rs2_src_id2ex_o ),
        .ex_forward_ex_rs2_src_ex2mem_o( ex_forward_ex_rs2_src_ex2mem_o ),
        .ex_forward_ex_rs2_src_mem2wb_o( ex_forward_ex_rs2_src_mem2wb_o )
    );

endmodule