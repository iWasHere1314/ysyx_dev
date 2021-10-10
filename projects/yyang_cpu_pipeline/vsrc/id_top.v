`include "defines.v"
module id_top (
    input                       clk,
    input                       rst,

    /* control signals */
    input                       id_top_inst_valid_i,
    

    input                       id_top_id2ex_inst_lui_i,

    input                       id_top_id2ex_rd_en_i,
    input                       id_top_ex2mem_rd_en_i,
    input                       id_top_mem2wb_rd_en_i,

    input   [`REG_INDEX_BUS]    id_top_id2ex_rd_index_i,
    input   [`REG_INDEX_BUS]    id_top_ex2mem_rd_index_i,
    input   [`REG_INDEX_BUS]    id_top_mem2wb_rd_index_i,
    
    output  [`REG_INDEX_BUS]    id_top_rs1_index_o,
    output  [`REG_INDEX_BUS]    id_top_rs2_index_o,
    output  [`REG_INDEX_BUS]    id_top_rd_index_o,
    output  [`CSR_INDEX_BUS]    id_top_csr_index_o,


    output                      id_top_id_rs1_src_id2ex_o,
    output                      id_top_id_rs1_src_ex2mem_o,
    output                      id_top_id_rs2_src_id2ex_o,
    output                      id_top_id_rs2_src_ex2mem_o,

    output                      id_top_rs1_en_o,
    output                      id_top_rs2_en_o,
    output                      id_top_rd_en_o,
    output                      id_top_inst_jump_o,
    output                      id_top_inst_branch_o,
    output                      id_top_inst_lui_o,

    output                      id_top_inst_word_o,
    output                      id_top_inst_slt_nu_o,
    output                      id_top_inst_slt_u_o,
    output                      id_top_inst_shift_o,
    output                      id_top_alu_src_pc_o,
    output                      id_top_alu_src_imm_o,
    output                      id_top_shift_num_src_o,
    output  [`SHIFT_TYPE_BUS]   id_top_shift_type_o,
    output                      id_top_inst_arth_lgc_o,
    output                      id_top_inst_auipc_o,
    output  [`ALU_OP_BUS]       id_top_alu_op_o,

    output                      id_top_inst_csr_o,
    output                      id_top_inst_load_o,
    output                      id_top_mem_write_o,
    output                      id_top_mem_read_o,
    output  [`STORE_TYPE_BUS]   id_top_store_type_o,
    output  [`LOAD_TYPE_BUS]    id_top_load_type_o,
    output                      id_top_csr_src_o,
    output  [`CSR_CTRL_BUS]     id_top_csr_ctrl_o,
    output                      id_top_inst_ecall_o,
    output                      id_top_inst_ebreak_o,
    output                      id_top_inst_mret_o,
    output                      id_top_inst_trap_o,

    output                      id_top_jumpbranch_en_o,

    `ifdef DEFINE_PUTCH
    output                      id_top_inst_selfdefine_o,
    `endif

    /* data signals */
    input   [`INST_BUS]         id_top_inst_i,
    input   [`INST_ADDR_BUS]    id_top_inst_addr_i,
    input   [`INST_ADDR_BUS]    id_top_nxt_inst_addr_i,
    input   [`DATA_BUS]         id_top_id2ex_rd_data_i,
    input   [`DATA_BUS]         id_top_ex2mem_rd_data_i,
    input   [`DATA_BUS]         id_top_mem2wb_rd_data_i,

    output  [`REG_BUS]          id_top_rs1_data_o,
    output  [`REG_BUS]          id_top_rs2_data_o,
    output  [`DATA_BUS]         id_top_imm_data_o,
    output  [`DATA_BUS]         id_top_rd_data_o,
    output  [`INST_ADDR_BUS]    id_top_inst_addr_o,
    output  [`INST_ADDR_BUS]    id_top_jumpbranch_addr_o
    `ifdef DEFINE_DIFFTEST  
    ,
    output    [`REG_BUS]        id_top_regs_o[31:0]
    `endif
);
    
    wire                        id_control_rs1_en_o;
    wire                        id_control_rs2_en_o;
    wire                        id_control_rd_en_o;
    wire                        id_control_jump_base_pc_o;
    wire    [`COMP_TYPE_BUS]    id_control_comp_type_o;
    wire                        id_control_inst_jump_o;
    wire                        id_control_inst_branch_o;
    wire                        id_control_inst_lui_o;
    wire    [`GEN_TYPE_BUS]     id_control_gen_type_o;
    wire                        id_control_inst_word_o;
    wire                        id_control_inst_slt_nu_o;
    wire                        id_control_inst_slt_u_o;
    wire                        id_control_inst_shift_o;
    wire                        id_control_alu_src_pc_o;
    wire                        id_control_alu_src_imm_o;
    wire                        id_control_shift_num_src_o;
    wire    [`SHIFT_TYPE_BUS]   id_control_shift_type_o;
    wire                        id_control_inst_arth_lgc_o;
    wire                        id_control_inst_auipc_o;
    wire    [`ALU_OP_BUS]       id_control_alu_op_o;
    wire                        id_control_inst_csr_o;
    wire                        id_control_inst_load_o;
    wire                        id_control_mem_write_o;
    wire                        id_control_mem_read_o;
    wire    [`STORE_TYPE_BUS]   id_control_store_type_o;
    wire    [`LOAD_TYPE_BUS]    id_control_load_type_o;
    wire                        id_control_csr_src_o;
    wire    [`CSR_CTRL_BUS]     id_control_csr_ctrl_o;
    wire                        id_control_inst_ecall_o;
    wire                        id_control_inst_ebreak_o;
    wire                        id_control_inst_mret_o;
    wire                        id_control_inst_trap_o;
    
    `ifdef DEFINE_PUTCH 
    wire                        id_control_inst_selfdefine_o;
    `endif  
    
    wire                        id_branchjudge_ok_o;

    wire    [`DATA_BUS]         id_immgen_imm_data_o;

    wire                        id_forward_id_rs1_src_reg_o;
    wire                        id_forward_id_rs1_src_id2ex_o;
    wire                        id_forward_id_rs1_src_ex2mem_o;
    wire                        id_forward_id_rs1_src_mem2wb_o;
    wire                        id_forward_id_rs2_src_reg_o;
    wire                        id_forward_id_rs2_src_id2ex_o;
    wire                        id_forward_id_rs2_src_ex2mem_o;
    wire                        id_forward_id_rs2_src_mem2wb_o;

    wire    [`REG_BUS]          id_regfile_rs1_data_o;
    wire    [`REG_BUS]          id_regfile_rs2_data_o;

    `ifdef DEFINE_DIFFTEST      
    wire    [`REG_BUS]          id_regfile_regs_o  [31:0] ;
    `endif


    wire    [`REG_BUS]          id_rs1_data;
    wire    [`REG_BUS]          id_rs2_data;

    wire    [`INST_ADDR_BUS]    jumpbranch_base;


    assign id_rs1_data                  =     ( { 64 { id_forward_id_rs1_src_reg_o } } & id_regfile_rs1_data_o ) 
                                            | ( { 64 { id_forward_id_rs1_src_id2ex_o } } & id_top_id2ex_rd_data_i )
                                            | ( { 64 { id_forward_id_rs1_src_ex2mem_o } } & id_top_ex2mem_rd_data_i )
                                            | ( { 64 { id_forward_id_rs1_src_mem2wb_o} } & id_top_mem2wb_rd_data_i );
    assign id_rs2_data                  =     ( { 64 { id_forward_id_rs2_src_reg_o } } & id_regfile_rs2_data_o ) 
                                            | ( { 64 { id_forward_id_rs2_src_id2ex_o } } & id_top_id2ex_rd_data_i )
                                            | ( { 64 { id_forward_id_rs2_src_ex2mem_o } } & id_top_ex2mem_rd_data_i )
                                            | ( { 64 { id_forward_id_rs2_src_mem2wb_o} } & id_top_mem2wb_rd_data_i );

    assign jumpbranch_base              =   ( id_control_jump_base_pc_o == 1'b0 ) ? id_top_inst_addr_i: id_rs1_data;
    

    /* control signals */
    assign id_top_rs1_index_o           =   id_top_inst_i[`RS1_LOC_BUS];
    assign id_top_rs2_index_o           =   id_top_inst_i[`RS2_LOC_BUS];
    assign id_top_rd_index_o            =   id_top_inst_i[`RD_LOC_BUS];
    assign id_top_csr_index_o           =   id_top_inst_i[`CSR_LOC_BUS];



    assign id_top_id_rs1_src_id2ex_o    =   id_forward_id_rs1_src_id2ex_o;
    assign id_top_id_rs1_src_ex2mem_o   =   id_forward_id_rs1_src_ex2mem_o;
    assign id_top_id_rs2_src_id2ex_o    =   id_forward_id_rs2_src_id2ex_o;
    assign id_top_id_rs2_src_ex2mem_o   =   id_forward_id_rs2_src_ex2mem_o;

    assign id_top_rs1_en_o              =   id_control_rs1_en_o;
    assign id_top_rs2_en_o              =   id_control_rs2_en_o;
    assign id_top_rd_en_o               =   id_control_rd_en_o;
    assign id_top_inst_jump_o           =   id_control_inst_jump_o;
    assign id_top_inst_branch_o         =   id_control_inst_branch_o;
    assign id_top_inst_lui_o            =   id_control_inst_lui_o;

    assign id_top_inst_word_o           =   id_control_inst_word_o;
    assign id_top_inst_slt_nu_o         =   id_control_inst_slt_nu_o;
    assign id_top_inst_slt_u_o          =   id_control_inst_slt_u_o;
    assign id_top_inst_shift_o          =   id_control_inst_shift_o;
    assign id_top_alu_src_pc_o          =   id_control_alu_src_pc_o;
    assign id_top_alu_src_imm_o         =   id_control_alu_src_imm_o;
    assign id_top_shift_num_src_o       =   id_control_shift_num_src_o;
    assign id_top_shift_type_o          =   id_control_shift_type_o;
    assign id_top_inst_arth_lgc_o       =   id_control_inst_arth_lgc_o;
    assign id_top_inst_auipc_o          =   id_control_inst_auipc_o;
    assign id_top_alu_op_o              =   id_control_alu_op_o;

    assign id_top_inst_csr_o            =   id_control_inst_csr_o;
    assign id_top_inst_load_o           =   id_control_inst_load_o;
    assign id_top_mem_write_o           =   id_control_mem_write_o;
    assign id_top_mem_read_o            =   id_control_mem_read_o;
    assign id_top_store_type_o          =   id_control_store_type_o;
    assign id_top_load_type_o           =   id_control_load_type_o;
    assign id_top_csr_src_o             =   id_control_csr_src_o;
    assign id_top_csr_ctrl_o            =   id_control_csr_ctrl_o;
    assign id_top_inst_ecall_o          =   id_control_inst_ecall_o;
    assign id_top_inst_ebreak_o         =   id_control_inst_ebreak_o;
    assign id_top_inst_mret_o           =   id_control_inst_mret_o;
    assign id_top_inst_trap_o           =   id_control_inst_trap_o;

    assign id_top_jumpbranch_en_o       =   ( id_branchjudge_ok_o & id_control_inst_branch_o ) | id_control_inst_jump_o;

    `ifdef DEFINE_PUTCH
    assign id_top_inst_selfdefine_o     =   id_control_inst_selfdefine_o;
    `endif

    /* data signals */

    assign id_top_rs1_data_o            =   id_rs1_data;
    assign id_top_rs2_data_o            =   id_rs2_data;
    assign id_top_imm_data_o            =   id_immgen_imm_data_o;
    assign id_top_rd_data_o             =   id_control_inst_lui_o? id_immgen_imm_data_o: id_top_nxt_inst_addr_i;
    assign id_top_inst_addr_o           =   id_top_inst_addr_i;
    assign id_top_jumpbranch_addr_o     =   jumpbranch_base + id_immgen_imm_data_o;
    `ifdef DEFINE_DIFFTEST  
    assign id_top_regs_o                =   id_regfile_regs_o;
    `endif

    id_control my_id_control(


        .id_control_inst_i( id_top_inst_i ),

        .id_control_opcode_i( id_top_inst_i[`OPCODE_LOC_BUS] ),
        .id_control_funct3_i( id_top_inst_i[`FUNCT3_LOC_BUS] ),
        .id_control_funct7_i( id_top_inst_i[`FUNCT7_LOC_BUS] ),

        /* id */
        .id_control_rs1_en_o( id_control_rs1_en_o ),
        .id_control_rs2_en_o( id_control_rs2_en_o ),
        .id_control_rd_en_o( id_control_rd_en_o ),
        .id_control_jump_base_pc_o( id_control_jump_base_pc_o ),
        .id_control_comp_type_o( id_control_comp_type_o ),
        .id_control_inst_jump_o( id_control_inst_jump_o ),
        .id_control_inst_branch_o( id_control_inst_branch_o ),
        .id_control_inst_lui_o( id_control_inst_lui_o ),
        .id_control_gen_type_o( id_control_gen_type_o ),

        /* ex */
        .id_control_inst_word_o( id_control_inst_word_o ),
        .id_control_inst_slt_nu_o( id_control_inst_slt_nu_o ),
        .id_control_inst_slt_u_o( id_control_inst_slt_u_o ),
        .id_control_inst_shift_o( id_control_inst_shift_o ),
        .id_control_alu_src_pc_o( id_control_alu_src_pc_o ),
        .id_control_alu_src_imm_o( id_control_alu_src_imm_o ),
        .id_control_shift_num_src_o( id_control_shift_num_src_o ),
        .id_control_shift_type_o( id_control_shift_type_o ),
        .id_control_inst_arth_lgc_o( id_control_inst_arth_lgc_o ),
        .id_control_inst_auipc_o( id_control_inst_auipc_o ),
        .id_control_alu_op_o( id_control_alu_op_o ),

        /* mem */
        .id_control_inst_csr_o( id_control_inst_csr_o ),
        .id_control_inst_load_o( id_control_inst_load_o ),
        .id_control_mem_write_o( id_control_mem_write_o ),
        .id_control_mem_read_o( id_control_mem_read_o ),
        .id_control_store_type_o( id_control_store_type_o ),
        .id_control_load_type_o( id_control_load_type_o ),
        .id_control_csr_src_o( id_control_csr_src_o ),
        .id_control_csr_ctrl_o( id_control_csr_ctrl_o ),
        .id_control_inst_ecall_o( id_control_inst_ecall_o ),
        .id_control_inst_ebreak_o( id_control_inst_ebreak_o ),
        .id_control_inst_mret_o( id_control_inst_mret_o ),
        .id_control_inst_trap_o( id_control_inst_trap_o )

        `ifdef DEFINE_PUTCH
        ,
        .id_control_inst_selfdefine_o( id_control_inst_selfdefine_o )
        `endif
    );

    id_regfile my_id_regfile(
        .clk( clk ),
        .rst( rst ),

        /* control signals */
        .id_regfile_inst_valid_i( id_top_inst_valid_i ),
        .id_regfile_rd_en_i( id_top_mem2wb_rd_en_i ),
        .id_regfile_rs1_en_i( id_control_rs1_en_o ),
        .id_regfile_rs2_en_i( id_control_rs2_en_o ),
        .id_regfile_rd_index_i( id_top_mem2wb_rd_index_i ),
        .id_regfile_rs1_index_i( id_top_inst_i[`RS1_LOC_BUS] ),
        .id_regfile_rs2_index_i( id_top_inst_i[`RS2_LOC_BUS] ),

        /* data signals */
        .id_regfile_rd_data_i( id_top_mem2wb_rd_data_i ),
        .id_regfile_rs1_data_o( id_regfile_rs1_data_o ),
        .id_regfile_rs2_data_o( id_regfile_rs2_data_o )

        `ifdef DEFINE_DIFFTEST
        /* difftest interface */
        ,
        .id_regfile_regs_o( id_regfile_regs_o )
        `endif
    );

    id_immgen my_id_immgen(
        /* control signals */
        .id_immgen_gen_type_i( id_control_gen_type_o ),

        /* data signals */
        .id_immgen_inst_i( id_top_inst_i ),    
        .id_immgen_imm_data_o( id_immgen_imm_data_o )
    );

    id_forward my_id_forward(
        /* control signals */
        .id_forward_inst_jump_i( id_control_inst_jump_o ),
        .id_forward_inst_branch_i( id_control_inst_branch_o ),
        .id_forward_id_rs1_en_i( id_control_rs1_en_o ),
        .id_forward_id_rs2_en_i( id_control_rs2_en_o ),
        .id_forward_id2ex_rd_en_i( id_top_id2ex_rd_en_i ),
        .id_forward_ex2mem_rd_en_i( id_top_ex2mem_rd_en_i ),
        .id_forward_mem2wb_rd_en_i( id_top_mem2wb_rd_en_i ),
        .id_forward_id_rs1_index_i( id_top_inst_i[`RS1_LOC_BUS]  ),
        .id_forward_id_rs2_index_i( id_top_inst_i[`RS2_LOC_BUS] ),
        .id_forward_id2ex_rd_index_i( id_top_id2ex_rd_index_i ),
        .id_forward_ex2mem_rd_index_i( id_top_ex2mem_rd_index_i ),
        .id_forward_mem2wb_rd_index_i( id_top_mem2wb_rd_index_i ),

        .id_forward_id_rs1_src_reg_o( id_forward_id_rs1_src_reg_o ),
        .id_forward_id_rs1_src_id2ex_o( id_forward_id_rs1_src_id2ex_o ),
        .id_forward_id_rs1_src_ex2mem_o( id_forward_id_rs1_src_ex2mem_o ),
        .id_forward_id_rs1_src_mem2wb_o( id_forward_id_rs1_src_mem2wb_o ),
        .id_forward_id_rs2_src_reg_o( id_forward_id_rs2_src_reg_o ),
        .id_forward_id_rs2_src_id2ex_o( id_forward_id_rs2_src_id2ex_o ),
        .id_forward_id_rs2_src_ex2mem_o( id_forward_id_rs2_src_ex2mem_o ),
        .id_forward_id_rs2_src_mem2wb_o( id_forward_id_rs2_src_mem2wb_o )
    );
    
    id_branchjudge my_id_branchjudge(
        /* control signals */
        .id_branchjudge_comp_type_i( id_control_comp_type_o ),

        /* data signals */
        .id_branchjudge_rs1_data_i( id_rs1_data ),
        .id_branchjudge_rs2_data_i( id_rs2_data ),
        .id_branchjudge_ok_o( id_branchjudge_ok_o )
    );

endmodule