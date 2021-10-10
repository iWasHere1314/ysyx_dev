`include "defines.v"
module cpu(
    input                       clock,
    input                       reset,
    
    input                       if_ready,
    input   [`DATA_BUS]         if_data_read,
    input   [1:0]               if_resp,
    output                      if_valid,
    output  [`INST_ADDR_BUS]    if_addr,
    output  [1:0]               if_size,
    output                      if_req,

    output                      cpu_mem_valid,
    input                       cpu_mem_ready,
    input   [`DATA_BUS]         cpu_mem_data_read,
    output  [`DATA_BUS]         cpu_mem_data_write,
    output  [`DATA_ADDR_BUS]    cpu_mem_addr,
    output  [1:0]               cpu_mem_size,
    input   [1:0]               cpu_mem_resp,
    output                      cpu_mem_req
);

    /* if_top */
    wire                        if_top_fetched_ok_o;
    wire    [`INST_ADDR_BUS]    if_top_inst_addr_o;
    wire    [`INST_BUS]         if_top_inst_o;

    /* if2id */
    wire                        if2id_inst_nop_o;
    wire    [`INST_ADDR_BUS]    if2id_inst_addr_o;
    wire    [`INST_BUS]         if2id_inst_o;

    /* id_top */
    wire    [`REG_INDEX_BUS]    id_top_rs1_index_o;
    wire    [`REG_INDEX_BUS]    id_top_rs2_index_o;
    wire    [`REG_INDEX_BUS]    id_top_rd_index_o;
    wire    [`CSR_INDEX_BUS]    id_top_csr_index_o;
    wire                        id_top_id_rs1_src_id2ex_o;
    wire                        id_top_id_rs1_src_ex2mem_o;
    wire                        id_top_id_rs2_src_id2ex_o;
    wire                        id_top_id_rs2_src_ex2mem_o;
    wire                        id_top_rs1_en_o;
    wire                        id_top_rs2_en_o;
    wire                        id_top_rd_en_o;
    wire                        id_top_inst_lui_o;
    wire                        id_top_inst_jump_o;
    wire                        id_top_inst_branch_o;
    wire                        id_top_inst_word_o;
    wire                        id_top_inst_slt_nu_o;
    wire                        id_top_inst_slt_u_o;
    wire                        id_top_inst_shift_o;
    wire                        id_top_alu_src_pc_o;
    wire                        id_top_alu_src_imm_o;
    wire                        id_top_shift_num_src_o;
    wire    [`SHIFT_TYPE_BUS]   id_top_shift_type_o;
    wire                        id_top_inst_arth_lgc_o;
    wire                        id_top_inst_auipc_o;
    wire    [`ALU_OP_BUS]       id_top_alu_op_o;
    wire                        id_top_inst_csr_o;
    wire                        id_top_inst_load_o;
    wire                        id_top_mem_write_o;
    wire                        id_top_mem_read_o;
    wire    [`STORE_TYPE_BUS]   id_top_store_type_o;
    wire    [`LOAD_TYPE_BUS]    id_top_load_type_o;
    wire                        id_top_csr_src_o;
    wire    [`CSR_CTRL_BUS]     id_top_csr_ctrl_o;
    wire                        id_top_inst_ecall_o;
    wire                        id_top_inst_ebreak_o;
    wire                        id_top_inst_mret_o;
    wire                        id_top_inst_trap_o;
    wire                        id_top_jumpbranch_en_o;

    `ifdef DEFINE_PUTCH
    wire                        id_top_inst_selfdefine_o;
    `endif

    wire    [`REG_BUS]          id_top_rs1_data_o;
    wire    [`REG_BUS]          id_top_rs2_data_o;
    wire    [`DATA_BUS]         id_top_imm_data_o;
    wire    [`DATA_BUS]         id_top_rd_data_o;
    wire    [`INST_ADDR_BUS]    id_top_inst_addr_o;
    wire    [`INST_ADDR_BUS]    id_top_jumpbranch_addr_o;

    `ifdef DEFINE_DIFFTEST  
    wire      [`REG_BUS]        id_top_regs_o[31:0];
    `endif

    /* id2ex */
    wire    [`REG_INDEX_BUS]    id2ex_rs1_index_o;
    wire    [`REG_INDEX_BUS]    id2ex_rs2_index_o;
    wire    [`REG_INDEX_BUS]    id2ex_rd_index_o;
    wire    [`CSR_INDEX_BUS]    id2ex_csr_index_o;
    wire                        id2ex_inst_nop_o;
    wire                        id2ex_rs1_en_o;
    wire                        id2ex_rs2_en_o;
    wire                        id2ex_rd_en_o;
    wire                        id2ex_inst_jump_o;
    wire                        id2ex_inst_branch_o;
    wire                        id2ex_inst_lui_o;
    wire                        id2ex_inst_word_o;
    wire                        id2ex_inst_slt_nu_o;
    wire                        id2ex_inst_slt_u_o;
    wire                        id2ex_inst_shift_o;
    wire                        id2ex_alu_src_pc_o;
    wire                        id2ex_alu_src_imm_o;
    wire                        id2ex_shift_num_src_o;
    wire    [`SHIFT_TYPE_BUS]   id2ex_shift_type_o;
    wire                        id2ex_inst_arth_lgc_o;
    wire                        id2ex_inst_auipc_o;
    wire    [`ALU_OP_BUS]       id2ex_alu_op_o;
    wire                        id2ex_inst_csr_o;
    wire                        id2ex_inst_load_o;
    wire                        id2ex_mem_write_o;
    wire                        id2ex_mem_read_o;
    wire    [`STORE_TYPE_BUS]   id2ex_store_type_o;
    wire    [`LOAD_TYPE_BUS]    id2ex_load_type_o;
    wire                        id2ex_csr_src_o;
    wire    [`CSR_CTRL_BUS]     id2ex_csr_ctrl_o;
    wire                        id2ex_inst_ecall_o;
    wire                        id2ex_inst_ebreak_o;
    wire                        id2ex_inst_mret_o;
    wire                        id2ex_inst_trap_o;
    wire                        id2ex_jumpbranch_en_o;
    `ifdef DEFINE_PUTCH
    wire                        id2ex_inst_selfdefine_o;
    `endif
    `ifdef DEFINE_DIFFTEST
    wire    [`INST_BUS]         id2ex_inst_o;
    `endif
    wire    [`REG_BUS]          id2ex_rs1_data_o;
    wire    [`REG_BUS]          id2ex_rs2_data_o;
    wire    [`DATA_BUS]         id2ex_imm_data_o;
    wire    [`DATA_BUS]         id2ex_rd_data_o;
    wire    [`INST_ADDR_BUS]    id2ex_inst_addr_o;
    wire    [`INST_ADDR_BUS]    id2ex_jumpbranch_addr_o;

    /* ex_top */
    wire                        ex_top_ex_rs1_src_ex2mem_o;
    wire                        ex_top_ex_rs2_src_ex2mem_o;
    wire                        ex_top_ex_rs1_src_mem2wb_o;
    wire                        ex_top_ex_rs2_src_mem2wb_o;
    wire    [`DATA_BUS]         ex_top_rs1_data_o;
    wire    [`DATA_BUS]         ex_top_rs2_data_o;
    wire    [`DATA_BUS]         ex_top_rd_data_o;

    /* ex2mem */
    wire    [`REG_INDEX_BUS]    ex2mem_rs1_index_o;
    wire    [`REG_INDEX_BUS]    ex2mem_rs2_index_o;
    wire    [`REG_INDEX_BUS]    ex2mem_rd_index_o;
    wire                        ex2mem_rs1_en_o;
    wire                        ex2mem_rs2_en_o;
    wire                        ex2mem_rd_en_o;
    wire    [`CSR_INDEX_BUS]    ex2mem_csr_index_o;
    wire                        ex2mem_inst_csr_o;
    wire                        ex2mem_inst_load_o;
    wire                        ex2mem_mem_write_o;
    wire                        ex2mem_mem_read_o;
    wire    [`STORE_TYPE_BUS]   ex2mem_store_type_o;
    wire    [`LOAD_TYPE_BUS]    ex2mem_load_type_o;
    wire                        ex2mem_csr_src_o;
    wire    [`CSR_CTRL_BUS]     ex2mem_csr_ctrl_o;
    wire                        ex2mem_inst_ecall_o;
    wire                        ex2mem_inst_ebreak_o;
    wire                        ex2mem_inst_mret_o;
    wire                        ex2mem_inst_trap_o;
    `ifdef DEFINE_DIFFTEST
    wire                        ex2mem_inst_nop_o;
    wire    [`INST_BUS]         ex2mem_inst_o;
    `endif
    `ifdef DEFINE_PUTCH
    wire                        ex2mem_inst_selfdefine_o;
    `endif
    wire    [`REG_BUS]          ex2mem_rs1_data_o;
    wire    [`REG_BUS]          ex2mem_rs2_data_o;
    wire    [`DATA_BUS]         ex2mem_imm_data_o;
    wire    [`DATA_BUS]         ex2mem_rd_data_o;
    wire    [`INST_ADDR_BUS]    ex2mem_inst_addr_o;

    /* mem_top */
    wire    [`INST_ADDR_BUS]    mem_top_csr_nxt_pc_o;
    wire                        mem_top_intp_en_o;
    wire                        mem_top_csr_trap_o;
    wire                        mem_top_access_ok_o;
    wire    [`DATA_BUS]         mem_top_rd_data_o;
    `ifdef DEFINE_DIFFTEST
    wire                        mem_top_csr_skip_o;
    wire    [`REG_BUS]          mem_top_mstatus_o;
    wire    [`REG_BUS]          mem_top_mtvec_o;
    wire    [`REG_BUS]          mem_top_mepc_o;
    wire    [`REG_BUS]          mem_top_mcause_o;
    wire    [`REG_BUS]          mem_top_mip_o;
    wire    [`REG_BUS]          mem_top_mie_o;
    wire    [`REG_BUS]          mem_top_mscratch_o;
    wire    [31:0]              mem_top_cause_o;
    wire                        mem_top_clint_dstb_skip_o;
    `endif

    /* mem2wb */
    wire    [`REG_INDEX_BUS]    mem2wb_rd_index_o;
    wire                        mem2wb_rd_en_o;
    wire                        mem2wb_inst_trap_o;
    wire                        mem2wb_intp_en_o;
    `ifdef DEFINE_DIFFTEST
    wire                        mem2wb_inst_csr_o;
    wire                        mem2wb_inst_nop_o;
    wire                        mem2wb_csr_skip_o;
    wire    [`REG_BUS]          mem2wb_mstatus_o;
    wire    [`REG_BUS]          mem2wb_mtvec_o;
    wire    [`REG_BUS]          mem2wb_mepc_o;
    wire    [`REG_BUS]          mem2wb_mcause_o;
    wire    [`REG_BUS]          mem2wb_mip_o;
    wire    [`REG_BUS]          mem2wb_mie_o;
    wire    [`REG_BUS]          mem2wb_mscratch_o;
    wire    [31:0]              mem2wb_cause_o;
    wire                        mem2wb_clint_dstb_skip_o;
    wire    [`INST_BUS]         mem2wb_inst_o;
    wire    [`INST_ADDR_BUS]    mem2wb_inst_addr_o;
    `endif
    `ifdef DEFINE_PUTCH
    wire                        mem2wb_inst_selfdefine_o;
    `endif
    wire    [`DATA_BUS]         mem2wb_rd_data_o;
    wire    [`INST_ADDR_BUS]    mem2wb_csr_nxt_pc_o;

    /* pipeline_control */
    wire                        pipeline_ctrl_inst_valid_o;
    wire                        pipeline_ctrl_dont_fetch_o;
    wire                        pipeline_ctrl_if_flush_o;
    wire                        pipeline_ctrl_id_stall_o;
    wire                        pipeline_ctrl_id_flush_o;
    wire                        pipeline_ctrl_ex_stall_o;
    wire                        pipeline_ctrl_ex_flush_o;
    wire                        pipeline_ctrl_intp_en_o;
    wire                        pipeline_ctrl_ex_rs1_src_buffer_o;
    wire                        pipeline_ctrl_ex_rs2_src_buffer_o;
    wire                        pipeline_ctrl_ex_rs1_buffered_o;
    wire                        pipeline_ctrl_ex_rs2_buffered_o;
    /* wb */
    wire                        wb_trap_en_o;

    assign wb_trap_en_o             =   mem2wb_intp_en_o | mem2wb_inst_trap_o;

    if_top my_if_top(
        .clk( clock ),
        .rst( reset ),

        /* control signals */
        .if_top_jumpbranch_en_i( id2ex_jumpbranch_en_o ),
        .if_top_trap_en_i( wb_trap_en_o ),
        .if_top_inst_valid_i( pipeline_ctrl_inst_valid_o ),
        .if_top_dont_fetch_i( pipeline_ctrl_dont_fetch_o ),

        .if_top_fetched_ok_o( if_top_fetched_ok_o ),

        /* data signals */
        .if_top_jumpbranch_addr_i( id2ex_jumpbranch_addr_o ),
        .if_top_csr_nxt_pc_i( mem2wb_csr_nxt_pc_o ),


        /* bus interface */
        .if_top_if_ready_i( if_ready ),
        .if_top_if_data_read_i( if_data_read ),
        .if_top_if_resp_i( if_resp ),

        .if_top_inst_addr_o( if_top_inst_addr_o ),
        .if_top_if_valid_o( if_valid ),
        .if_top_if_addr_o( if_addr ),
        .if_top_if_size_o( if_size ),
        .if_top_inst_o( if_top_inst_o ),
        .if_top_if_req_o( if_req )
    );

    if2id my_if2id(
        .clk( clock ),
        .rst( reset ),

        /* if2id control signals */
        .if2id_inst_valid_i( pipeline_ctrl_inst_valid_o ),
        .if2id_if_flush_i( pipeline_ctrl_if_flush_o ),
        .if2id_id_stall_i( pipeline_ctrl_id_stall_o ),
        /* modules controls signals */    
        .if2id_inst_nop_o( if2id_inst_nop_o ),

        /* data signals */
        .if2id_inst_addr_i( if_top_inst_addr_o ),
        .if2id_inst_i( if_top_inst_o ),

        .if2id_inst_addr_o( if2id_inst_addr_o ),
        .if2id_inst_o( if2id_inst_o )
    );

    id_top my_id_top(
        .clk( clock ),
        .rst( reset ),

        /* control signals */
        .id_top_inst_valid_i( pipeline_ctrl_inst_valid_o ),


        .id_top_id2ex_inst_lui_i( id2ex_inst_lui_o ),

        .id_top_id2ex_rd_en_i( id2ex_rd_en_o ),
        .id_top_ex2mem_rd_en_i( ex2mem_rd_en_o ),
        .id_top_mem2wb_rd_en_i( mem2wb_rd_en_o ),

        .id_top_id2ex_rd_index_i( id2ex_rd_index_o ),
        .id_top_ex2mem_rd_index_i( ex2mem_rd_index_o ),
        .id_top_mem2wb_rd_index_i( mem2wb_rd_index_o ),

        .id_top_rs1_index_o( id_top_rs1_index_o ),
        .id_top_rs2_index_o( id_top_rs2_index_o ),
        .id_top_rd_index_o( id_top_rd_index_o ),
        .id_top_csr_index_o( id_top_csr_index_o ),


        .id_top_id_rs1_src_id2ex_o( id_top_id_rs1_src_id2ex_o ),
        .id_top_id_rs1_src_ex2mem_o( id_top_id_rs1_src_ex2mem_o ),
        .id_top_id_rs2_src_id2ex_o( id_top_id_rs2_src_id2ex_o ),
        .id_top_id_rs2_src_ex2mem_o( id_top_id_rs2_src_ex2mem_o ),

        .id_top_inst_lui_o( id_top_inst_lui_o ),
        .id_top_rs1_en_o( id_top_rs1_en_o ),
        .id_top_rs2_en_o( id_top_rs2_en_o ),
        .id_top_rd_en_o( id_top_rd_en_o ),
        .id_top_inst_jump_o( id_top_inst_jump_o ),
        .id_top_inst_branch_o( id_top_inst_branch_o ),

        .id_top_inst_word_o( id_top_inst_word_o ),
        .id_top_inst_slt_nu_o( id_top_inst_slt_nu_o ),
        .id_top_inst_slt_u_o( id_top_inst_slt_u_o ),
        .id_top_inst_shift_o( id_top_inst_shift_o ),
        .id_top_alu_src_pc_o( id_top_alu_src_pc_o ),
        .id_top_alu_src_imm_o( id_top_alu_src_imm_o ),
        .id_top_shift_num_src_o( id_top_shift_num_src_o ),
        .id_top_shift_type_o( id_top_shift_type_o ),
        .id_top_inst_arth_lgc_o( id_top_inst_arth_lgc_o ),
        .id_top_inst_auipc_o( id_top_inst_auipc_o ),
        .id_top_alu_op_o( id_top_alu_op_o ),

        .id_top_inst_csr_o( id_top_inst_csr_o ),
        .id_top_inst_load_o( id_top_inst_load_o ),
        .id_top_mem_write_o( id_top_mem_write_o ),
        .id_top_mem_read_o( id_top_mem_read_o ),
        .id_top_store_type_o( id_top_store_type_o ),
        .id_top_load_type_o( id_top_load_type_o ),
        .id_top_csr_src_o( id_top_csr_src_o ),
        .id_top_csr_ctrl_o( id_top_csr_ctrl_o ),
        .id_top_inst_ecall_o( id_top_inst_ecall_o ),
        .id_top_inst_ebreak_o( id_top_inst_ebreak_o ),
        .id_top_inst_mret_o( id_top_inst_mret_o ),
        .id_top_inst_trap_o( id_top_inst_trap_o ),

        .id_top_jumpbranch_en_o( id_top_jumpbranch_en_o ),

        `ifdef DEFINE_PUTCH
        .id_top_inst_selfdefine_o( id_top_inst_selfdefine_o ),
        `endif

        /* data signals */
        .id_top_inst_i( if2id_inst_o ),
        .id_top_inst_addr_i( if2id_inst_addr_o ),
        .id_top_nxt_inst_addr_i( if_top_inst_addr_o ),
        .id_top_id2ex_rd_data_i( id2ex_rd_data_o ),
        .id_top_ex2mem_rd_data_i( ex2mem_rd_data_o ),
        .id_top_mem2wb_rd_data_i( mem2wb_rd_data_o ),

        .id_top_rs1_data_o( id_top_rs1_data_o ),
        .id_top_rs2_data_o( id_top_rs2_data_o ),
        .id_top_imm_data_o( id_top_imm_data_o ),
        .id_top_rd_data_o( id_top_rd_data_o ),
        .id_top_inst_addr_o( id_top_inst_addr_o ),
        .id_top_jumpbranch_addr_o( id_top_jumpbranch_addr_o )
        `ifdef DEFINE_DIFFTEST  
        ,
        .id_top_regs_o( id_top_regs_o )
        `endif
    );

    id2ex my_id2ex(
        .clk( clock ),
        .rst( reset ),

        /* id2ex control signals */
        .id2ex_inst_valid_i( pipeline_ctrl_inst_valid_o ),
        .id2ex_id_flush_i( pipeline_ctrl_id_flush_o ),
        .id2ex_ex_stall_i( pipeline_ctrl_ex_stall_o ),
        /* modules control signals */
        .id2ex_rs1_index_i( id_top_rs1_index_o ),
        .id2ex_rs2_index_i( id_top_rs2_index_o ),
        .id2ex_rd_index_i( id_top_rd_index_o ),


        .id2ex_inst_nop_i( if2id_inst_nop_o ),

        .id2ex_rs1_en_i( id_top_rs1_en_o ),
        .id2ex_rs2_en_i( id_top_rs2_en_o ),
        .id2ex_rd_en_i( id_top_rd_en_o ),
        .id2ex_inst_jump_i( id_top_inst_jump_o ),
        .id2ex_inst_branch_i( id_top_inst_branch_o ),
        .id2ex_inst_lui_i( id_top_inst_lui_o ), 

        .id2ex_inst_word_i( id_top_inst_word_o ),
        .id2ex_inst_slt_nu_i( id_top_inst_slt_nu_o ),
        .id2ex_inst_slt_u_i( id_top_inst_slt_u_o ),
        .id2ex_inst_shift_i( id_top_inst_shift_o ),
        .id2ex_alu_src_pc_i( id_top_alu_src_pc_o ),
        .id2ex_alu_src_imm_i( id_top_alu_src_imm_o ),
        .id2ex_shift_num_src_i( id_top_shift_num_src_o ),
        .id2ex_shift_type_i( id_top_shift_type_o ),
        .id2ex_inst_arth_lgc_i( id_top_inst_arth_lgc_o ),
        .id2ex_inst_auipc_i( id_top_inst_auipc_o ),
        .id2ex_alu_op_i( id_top_alu_op_o ),

        .id2ex_csr_index_i( id_top_csr_index_o ),
        .id2ex_inst_csr_i( id_top_inst_csr_o ),
        .id2ex_inst_load_i( id_top_inst_load_o ),
        .id2ex_mem_write_i( id_top_mem_write_o ),
        .id2ex_mem_read_i( id_top_mem_read_o ),
        .id2ex_store_type_i( id_top_store_type_o ),
        .id2ex_load_type_i( id_top_load_type_o ),
        .id2ex_csr_src_i( id_top_csr_src_o ),
        .id2ex_csr_ctrl_i( id_top_csr_ctrl_o ),
        .id2ex_inst_ecall_i( id_top_inst_ecall_o ),
        .id2ex_inst_ebreak_i( id_top_inst_ebreak_o ),
        .id2ex_inst_mret_i( id_top_inst_mret_o ),
        .id2ex_inst_trap_i( id_top_inst_trap_o ),

        .id2ex_jumpbranch_en_i( id_top_jumpbranch_en_o ),

        `ifdef DEFINE_PUTCH
        .id2ex_inst_selfdefine_i( id_top_inst_selfdefine_o ),
        `endif
        `ifdef DEFINE_DIFFTEST
        .id2ex_inst_i( if2id_inst_o ),
        `endif
        .id2ex_rs1_index_o( id2ex_rs1_index_o ),
        .id2ex_rs2_index_o( id2ex_rs2_index_o ),
        .id2ex_rd_index_o( id2ex_rd_index_o ),
        .id2ex_csr_index_o( id2ex_csr_index_o ),

        .id2ex_inst_nop_o( id2ex_inst_nop_o ),

        .id2ex_rs1_en_o( id2ex_rs1_en_o ),
        .id2ex_rs2_en_o( id2ex_rs2_en_o ),
        .id2ex_rd_en_o( id2ex_rd_en_o ),
        .id2ex_inst_jump_o( id2ex_inst_jump_o ),
        .id2ex_inst_branch_o( id2ex_inst_branch_o ),
        .id2ex_inst_lui_o( id2ex_inst_lui_o ),

        .id2ex_inst_word_o( id2ex_inst_word_o ),
        .id2ex_inst_slt_nu_o( id2ex_inst_slt_nu_o ),
        .id2ex_inst_slt_u_o( id2ex_inst_slt_u_o ),
        .id2ex_inst_shift_o( id2ex_inst_shift_o ),
        .id2ex_alu_src_pc_o( id2ex_alu_src_pc_o ),
        .id2ex_alu_src_imm_o( id2ex_alu_src_imm_o ),
        .id2ex_shift_num_src_o( id2ex_shift_num_src_o ),
        .id2ex_shift_type_o( id2ex_shift_type_o ),
        .id2ex_inst_arth_lgc_o( id2ex_inst_arth_lgc_o ),
        .id2ex_inst_auipc_o( id2ex_inst_auipc_o ),
        .id2ex_alu_op_o( id2ex_alu_op_o ),

        .id2ex_inst_csr_o( id2ex_inst_csr_o ),
        .id2ex_inst_load_o( id2ex_inst_load_o ),
        .id2ex_mem_write_o( id2ex_mem_write_o ),
        .id2ex_mem_read_o( id2ex_mem_read_o ),
        .id2ex_store_type_o( id2ex_store_type_o ),
        .id2ex_load_type_o( id2ex_load_type_o ),
        .id2ex_csr_src_o( id2ex_csr_src_o ),
        .id2ex_csr_ctrl_o( id2ex_csr_ctrl_o ),
        .id2ex_inst_ecall_o( id2ex_inst_ecall_o ),
        .id2ex_inst_ebreak_o( id2ex_inst_ebreak_o ),
        .id2ex_inst_mret_o( id2ex_inst_mret_o ),
        .id2ex_inst_trap_o( id2ex_inst_trap_o ),

        .id2ex_jumpbranch_en_o( id2ex_jumpbranch_en_o ),

        `ifdef DEFINE_PUTCH
        .id2ex_inst_selfdefine_o( id2ex_inst_selfdefine_o ),
        `endif
        `ifdef DEFINE_DIFFTEST
        .id2ex_inst_o( id2ex_inst_o ),
        `endif
        /* data signals */
        .id2ex_rs1_data_i( id_top_rs1_data_o ),
        .id2ex_rs2_data_i( id_top_rs2_data_o ),
        .id2ex_imm_data_i( id_top_imm_data_o ),
        .id2ex_rd_data_i( id_top_rd_data_o ),
        .id2ex_inst_addr_i( id_top_inst_addr_o ),
        .id2ex_jumpbranch_addr_i( id_top_jumpbranch_addr_o ),

        .id2ex_rs1_data_o( id2ex_rs1_data_o ),
        .id2ex_rs2_data_o( id2ex_rs2_data_o ),
        .id2ex_imm_data_o( id2ex_imm_data_o ),
        .id2ex_rd_data_o( id2ex_rd_data_o ),
        .id2ex_inst_addr_o( id2ex_inst_addr_o ),
        .id2ex_jumpbranch_addr_o( id2ex_jumpbranch_addr_o )
    );

    ex_top my_ex_top(
        .clk( clock ),
        .rst( reset ),

        /* control signals */
        .ex_top_inst_valid_i( pipeline_ctrl_inst_valid_o ),

        .ex_top_rs1_buffered_i( pipeline_ctrl_ex_rs1_buffered_o ),
        .ex_top_rs2_buffered_i( pipeline_ctrl_ex_rs2_buffered_o ),
        .ex_top_rs1_src_buffer_i( pipeline_ctrl_ex_rs1_src_buffer_o ),
        .ex_top_rs2_src_buffer_i( pipeline_ctrl_ex_rs2_src_buffer_o ),
        .ex_top_id2ex_rs1_en_i( id2ex_rs1_en_o ),
        .ex_top_id2ex_rs2_en_i( id2ex_rs2_en_o ),
        .ex_top_ex2mem_rd_en_i( ex2mem_rd_en_o ),
        .ex_top_mem2wb_rd_en_i( mem2wb_rd_en_o ),
        .ex_top_inst_csr_i( id2ex_inst_csr_o ),
        .ex_top_inst_word_i( id2ex_inst_word_o ),
        .ex_top_inst_slt_nu_i( id2ex_inst_slt_nu_o ),
        .ex_top_inst_slt_u_i( id2ex_inst_slt_u_o ),
        .ex_top_inst_shift_i( id2ex_inst_shift_o ),
        .ex_top_alu_src_pc_i( id2ex_alu_src_pc_o ),
        .ex_top_alu_src_imm_i( id2ex_alu_src_imm_o ),
        .ex_top_shift_num_src_i( id2ex_shift_num_src_o ),
        .ex_top_shift_type_i( id2ex_shift_type_o ),
        .ex_top_inst_arth_lgc_i( id2ex_inst_arth_lgc_o ),
        .ex_top_inst_auipc_i( id2ex_inst_auipc_o ),
        .ex_top_alu_op_i( id2ex_alu_op_o ),

        .ex_top_mem_read_i( id2ex_mem_read_o ),
        .ex_top_mem_write_i( id2ex_mem_write_o ),
        .ex_top_id2ex_rs1_index_i( id2ex_rs1_index_o ),
        .ex_top_id2ex_rs2_index_i( id2ex_rs2_index_o ),
        .ex_top_ex2mem_rd_index_i( ex2mem_rd_index_o ),
        .ex_top_mem2wb_rd_index_i( mem2wb_rd_index_o ),


        .ex_top_ex_rs1_src_ex2mem_o( ex_top_ex_rs1_src_ex2mem_o ),
        .ex_top_ex_rs2_src_ex2mem_o( ex_top_ex_rs2_src_ex2mem_o ),
        .ex_top_ex_rs1_src_mem2wb_o( ex_top_ex_rs1_src_mem2wb_o ),
        .ex_top_ex_rs2_src_mem2wb_o( ex_top_ex_rs2_src_mem2wb_o ),
        /* data signals */
        .ex_top_imm_data_i( id2ex_imm_data_o ),
        .ex_top_id2ex_rs1_data_i( id2ex_rs1_data_o ),
        .ex_top_id2ex_rs2_data_i( id2ex_rs2_data_o ),
        .ex_top_id2ex_rd_data_i( id2ex_rd_data_o ),
        .ex_top_ex2mem_rd_data_i( ex2mem_rd_data_o ),
        .ex_top_mem2wb_rd_data_i( mem2wb_rd_data_o ),
        .ex_top_inst_addr_i( id2ex_inst_addr_o ),
        .ex_top_rs1_data_o( ex_top_rs1_data_o),
        .ex_top_rs2_data_o( ex_top_rs2_data_o),
        .ex_top_rd_data_o( ex_top_rd_data_o )
    );

    ex2mem my_ex2mem(
        .clk( clock ),
        .rst( reset ),

        /* id2ex control signals */
        .ex2mem_inst_valid_i( pipeline_ctrl_inst_valid_o ),
        .ex2mem_ex_flush_i( pipeline_ctrl_ex_flush_o ),

        /* modules control signals */
        .ex2mem_rs1_index_i( id2ex_rs1_index_o ),
        .ex2mem_rs2_index_i( id2ex_rs2_index_o ),
        .ex2mem_rd_index_i( id2ex_rd_index_o ),

        .ex2mem_rs1_en_i( id2ex_rs1_en_o ),
        .ex2mem_rs2_en_i( id2ex_rs1_en_o ),
        .ex2mem_rd_en_i( id2ex_rd_en_o ),

        .ex2mem_csr_index_i( id2ex_csr_index_o ),
        .ex2mem_inst_csr_i( id2ex_inst_csr_o ),
        .ex2mem_inst_load_i( id2ex_inst_load_o ),
        .ex2mem_mem_write_i( id2ex_mem_write_o ),
        .ex2mem_mem_read_i( id2ex_mem_read_o ),
        .ex2mem_store_type_i( id2ex_store_type_o ),
        .ex2mem_load_type_i( id2ex_load_type_o ),
        .ex2mem_csr_src_i( id2ex_csr_src_o ),
        .ex2mem_csr_ctrl_i( id2ex_csr_ctrl_o ),
        .ex2mem_inst_ecall_i( id2ex_inst_ecall_o ),
        .ex2mem_inst_ebreak_i( id2ex_inst_ebreak_o ),
        .ex2mem_inst_mret_i( id2ex_inst_mret_o ),
        .ex2mem_inst_trap_i( id2ex_inst_trap_o ),

        `ifdef DEFINE_DIFFTEST
        .ex2mem_inst_nop_i( id2ex_inst_nop_o ),
        .ex2mem_inst_i( id2ex_inst_o ),
        `endif

        `ifdef DEFINE_PUTCH
        .ex2mem_inst_selfdefine_i( id2ex_inst_selfdefine_o ),
        `endif

        .ex2mem_rs1_index_o( ex2mem_rs1_index_o ),
        .ex2mem_rs2_index_o( ex2mem_rs2_index_o ),
        .ex2mem_rd_index_o( ex2mem_rd_index_o ),

        .ex2mem_rs1_en_o( ex2mem_rs1_en_o ),
        .ex2mem_rs2_en_o( ex2mem_rs2_en_o ),
        .ex2mem_rd_en_o( ex2mem_rd_en_o ),

        .ex2mem_csr_index_o( ex2mem_csr_index_o ),
        .ex2mem_inst_csr_o( ex2mem_inst_csr_o ),
        .ex2mem_inst_load_o( ex2mem_inst_load_o ),
        .ex2mem_mem_write_o( ex2mem_mem_write_o ),
        .ex2mem_mem_read_o( ex2mem_mem_read_o ),
        .ex2mem_store_type_o( ex2mem_store_type_o ),
        .ex2mem_load_type_o( ex2mem_load_type_o ),
        .ex2mem_csr_src_o( ex2mem_csr_src_o ),
        .ex2mem_csr_ctrl_o( ex2mem_csr_ctrl_o ),
        .ex2mem_inst_ecall_o( ex2mem_inst_ecall_o ),
        .ex2mem_inst_ebreak_o( ex2mem_inst_ebreak_o ),
        .ex2mem_inst_mret_o( ex2mem_inst_mret_o ),
        .ex2mem_inst_trap_o( ex2mem_inst_trap_o ),

        `ifdef DEFINE_DIFFTEST
        .ex2mem_inst_nop_o( ex2mem_inst_nop_o ),
        .ex2mem_inst_o( ex2mem_inst_o ),
        `endif

        `ifdef DEFINE_PUTCH
        .ex2mem_inst_selfdefine_o( ex2mem_inst_selfdefine_o ),
        `endif

        /* data signals */
        .ex2mem_rs1_data_i( ex_top_rs1_data_o ),
        .ex2mem_rs2_data_i( ex_top_rs2_data_o ),
        .ex2mem_imm_data_i( id2ex_imm_data_o ),
        .ex2mem_rd_data_i( ex_top_rd_data_o ),
        .ex2mem_inst_addr_i( id2ex_inst_addr_o ),

        .ex2mem_rs1_data_o( ex2mem_rs1_data_o ),
        .ex2mem_rs2_data_o( ex2mem_rs2_data_o ),
        .ex2mem_imm_data_o( ex2mem_imm_data_o ),
        .ex2mem_rd_data_o( ex2mem_rd_data_o ),
        .ex2mem_inst_addr_o( ex2mem_inst_addr_o )
    );
    mem_top my_mem_top(
        .clk( clock ),
        .rst( reset ),

        /* control signals */
        .mem_top_inst_valid_i( pipeline_ctrl_inst_valid_o ),
        .mem_top_ex2mem_rs1_index_i( ex2mem_rs1_index_o ),
        .mem_top_ex2mem_rs2_index_i( ex2mem_rs2_index_o ),
        .mem_top_mem2wb_rd_index_i( mem2wb_rd_index_o ),

        .mem_top_ex2mem_rs1_en_i( ex2mem_rs1_en_o ),
        .mem_top_ex2mem_rs2_en_i( ex2mem_rs2_en_o ),
        .mem_top_mem2wb_rd_en_i( mem2wb_rd_en_o ),

        .mem_top_csr_index_i( ex2mem_csr_index_o ),
        .mem_top_inst_csr_i( ex2mem_inst_csr_o ),
        .mem_top_inst_load_i( ex2mem_inst_load_o ),
        .mem_top_mem_write_i( ex2mem_mem_write_o ),
        .mem_top_mem_read_i( ex2mem_mem_read_o ),
        .mem_top_store_type_i( ex2mem_store_type_o ),
        .mem_top_load_type_i( ex2mem_load_type_o ),
        .mem_top_csr_src_i( ex2mem_csr_src_o ),
        .mem_top_csr_ctrl_i( ex2mem_csr_ctrl_o ),
        .mem_top_inst_ecall_i( ex2mem_inst_ecall_o ),
        .mem_top_inst_ebreak_i( ex2mem_inst_ebreak_o ),
        .mem_top_inst_mret_i( ex2mem_inst_mret_o ),
        .mem_top_inst_trap_i( ex2mem_inst_trap_o ),

        .mem_top_intp_en_i( pipeline_ctrl_intp_en_o ),


        .mem_top_csr_nxt_pc_o( mem_top_csr_nxt_pc_o ),
        .mem_top_intp_en_o( mem_top_intp_en_o ),
        .mem_top_csr_trap_o( mem_top_csr_trap_o ),

        .mem_top_access_ok_o( mem_top_access_ok_o ),
        /* data signals */
        .mem_top_ex2mem_rs1_data_i( ex2mem_rs1_data_o ),
        .mem_top_ex2mem_rs2_data_i( ex2mem_rs2_data_o ),
        .mem_top_imm_data_i( ex2mem_imm_data_o ),
        .mem_top_ex2mem_rd_data_i( ex2mem_rd_data_o ),
        .mem_top_mem2wb_rd_data_i( mem2wb_rd_data_o ),
        .mem_top_ex2mem_inst_addr_i( ex2mem_inst_addr_o ),

        .mem_top_rd_data_o( mem_top_rd_data_o ),

        /* bus interface */
        .mem_top_mem_valid_o( cpu_mem_valid ),
        .mem_top_mem_ready_i( cpu_mem_ready ),
        .mem_top_mem_data_read_i( cpu_mem_data_read ),
        .mem_top_mem_data_write_o( cpu_mem_data_write ),
        .mem_top_mem_addr_o( cpu_mem_addr ),
        .mem_top_mem_size_o( cpu_mem_size ),
        .mem_top_mem_resp_i( cpu_mem_resp ),
        .mem_top_mem_req_o( cpu_mem_req )
        `ifdef DEFINE_DIFFTEST
        ,
        .mem_top_csr_skip_o( mem_top_csr_skip_o ),
        .mem_top_mstatus_o( mem_top_mstatus_o ),
        .mem_top_mtvec_o( mem_top_mtvec_o ),
        .mem_top_mepc_o( mem_top_mepc_o ),
        .mem_top_mcause_o( mem_top_mcause_o ),
        .mem_top_mip_o( mem_top_mip_o ),
        .mem_top_mie_o( mem_top_mie_o ),
        .mem_top_mscratch_o( mem_top_mscratch_o ),
        .mem_top_cause_o( mem_top_cause_o ),
        .mem_top_clint_dstb_skip_o( mem_top_clint_dstb_skip_o )
        `endif
    );

    mem2wb my_mem2wb(
        .clk( clock ),
        .rst( reset ),

        /* id2ex control signals */
        .mem2wb_inst_valid_i( pipeline_ctrl_inst_valid_o ),

        /* modules control signals */
        .mem2wb_rd_index_i( ex2mem_rd_index_o ),
        .mem2wb_rd_en_i( ex2mem_rd_en_o ),
        .mem2wb_inst_trap_i( ex2mem_inst_trap_o ),
        .mem2wb_intp_en_i( mem_top_intp_en_o ),
        `ifdef DEFINE_DIFFTEST
        .mem2wb_inst_csr_i( ex2mem_inst_csr_o),
        .mem2wb_inst_i( ex2mem_inst_o ),
        .mem2wb_inst_addr_i( ex2mem_inst_addr_o ),
        .mem2wb_inst_nop_i( ex2mem_inst_nop_o ),
        .mem2wb_csr_skip_i( mem_top_csr_skip_o ),
        .mem2wb_mstatus_i( mem_top_mstatus_o ),
        .mem2wb_mtvec_i( mem_top_mtvec_o ),
        .mem2wb_mepc_i( mem_top_mepc_o ),
        .mem2wb_mcause_i( mem_top_mcause_o ),
        .mem2wb_mip_i( mem_top_mip_o ),
        .mem2wb_mie_i( mem_top_mie_o ),
        .mem2wb_mscratch_i( mem_top_mscratch_o ),
        .mem2wb_cause_i( mem_top_cause_o ),
        .mem2wb_clint_dstb_skip_i( mem_top_clint_dstb_skip_o ),
        `endif

        `ifdef DEFINE_PUTCH
        .mem2wb_inst_selfdefine_i( ex2mem_inst_selfdefine_o ),
        `endif

        .mem2wb_rd_index_o( mem2wb_rd_index_o ),
        .mem2wb_rd_en_o( mem2wb_rd_en_o ),
        .mem2wb_inst_trap_o( mem2wb_inst_trap_o ),
        .mem2wb_intp_en_o( mem2wb_intp_en_o ),

        `ifdef DEFINE_DIFFTEST
        .mem2wb_inst_csr_o( mem2wb_inst_csr_o ),
        .mem2wb_inst_o( mem2wb_inst_o ),
        .mem2wb_inst_addr_o( mem2wb_inst_addr_o ),
        .mem2wb_inst_nop_o( mem2wb_inst_nop_o ),
        .mem2wb_csr_skip_o( mem2wb_csr_skip_o ),
        .mem2wb_mstatus_o( mem2wb_mstatus_o ),
        .mem2wb_mtvec_o( mem2wb_mtvec_o ),
        .mem2wb_mepc_o( mem2wb_mepc_o ),
        .mem2wb_mcause_o( mem2wb_mcause_o ),
        .mem2wb_mip_o( mem2wb_mip_o ),
        .mem2wb_mie_o( mem2wb_mie_o ),
        .mem2wb_mscratch_o( mem2wb_mscratch_o ),
        .mem2wb_cause_o( mem2wb_cause_o ),
        .mem2wb_clint_dstb_skip_o( mem2wb_clint_dstb_skip_o ),
        `endif

        `ifdef DEFINE_PUTCH
        .mem2wb_inst_selfdefine_o( mem2wb_inst_selfdefine_o ),
        `endif

        /* data signals */
        .mem2wb_rd_data_i( mem_top_rd_data_o ),
        .mem2wb_csr_nxt_pc_i( mem_top_csr_nxt_pc_o ),

        .mem2wb_rd_data_o( mem2wb_rd_data_o ),
        .mem2wb_csr_nxt_pc_o( mem2wb_csr_nxt_pc_o )
    );

    pipeline_ctrl my_pipeline_ctrl(
        .clk( clock ),
        .rst( reset ),

        .pipeline_ctrl_fetched_ok_i( if_top_fetched_ok_o ),

        .pipeline_ctrl_id_inst_branch_i( id_top_inst_branch_o ),
        .pipeline_ctrl_id_inst_jump_i( id_top_inst_jump_o ),
        .pipeline_ctrl_id_inst_trap_i( id_top_inst_trap_o ),
        .pipeline_ctrl_id_rs1_src_id2ex_i( id_top_id_rs1_src_id2ex_o ),
        .pipeline_ctrl_id_rs1_src_ex2mem_i( id_top_id_rs1_src_ex2mem_o ),
        .pipeline_ctrl_id_rs2_src_id2ex_i( id_top_id_rs2_src_id2ex_o ),
        .pipeline_ctrl_id_rs2_src_ex2mem_i( id_top_id_rs2_src_ex2mem_o ),

        .pipeline_ctrl_id2ex_inst_nop_i( id2ex_inst_nop_o ),
        .pipeline_ctrl_id2ex_inst_branch_i( id2ex_inst_branch_o ),
        .pipeline_ctrl_id2ex_inst_jump_i( id2ex_inst_jump_o ),
        .pipeline_ctrl_id2ex_inst_trap_i( id2ex_inst_trap_o ),
        .pipeline_ctrl_id2ex_inst_load_i( id2ex_inst_load_o ),
        .pipeline_ctrl_id2ex_inst_csr_i( id2ex_inst_csr_o ),
        .pipeline_ctrl_id2ex_inst_arth_lgc_i( id2ex_inst_arth_lgc_o ),
        .pipeline_ctrl_id2ex_inst_auipc_i( id2ex_inst_auipc_o ),
        .pipeline_ctrl_ex_rs1_src_ex2mem_i( ex_top_ex_rs1_src_ex2mem_o ),
        .pipeline_ctrl_ex_rs2_src_ex2mem_i( ex_top_ex_rs2_src_ex2mem_o ),
        .pipeline_ctrl_ex_rs1_src_mem2wb_i( ex_top_ex_rs1_src_mem2wb_o ),
        .pipeline_ctrl_ex_rs2_src_mem2wb_i( ex_top_ex_rs2_src_mem2wb_o ),

        .pipeline_ctrl_access_ok_i( mem_top_access_ok_o ),
        .pipeline_ctrl_mem_csr_trap_i( mem_top_csr_trap_o ),
        .pipeline_ctrl_ex2mem_inst_trap_i( ex2mem_inst_trap_o ),
        .pipeline_ctrl_ex2mem_inst_load_i( ex2mem_inst_load_o ),
        .pipeline_ctrl_ex2mem_mem_read_i( ex2mem_mem_read_o ),
        .pipeline_ctrl_ex2mem_mem_write_i( ex2mem_mem_write_o ),
        .pipeline_ctrl_ex2mem_inst_csr_i( ex2mem_inst_csr_o ),

        .pipeline_ctrl_mem2wb_inst_trap_i( mem2wb_inst_trap_o ),
        .pipeline_ctrl_mem2wb_intp_en_i( mem2wb_intp_en_o ),


        .pipeline_ctrl_inst_valid_o( pipeline_ctrl_inst_valid_o ),

        .pipeline_ctrl_dont_fetch_o( pipeline_ctrl_dont_fetch_o ),
        .pipeline_ctrl_if_flush_o( pipeline_ctrl_if_flush_o ),
        .pipeline_ctrl_id_stall_o( pipeline_ctrl_id_stall_o ),
        .pipeline_ctrl_id_flush_o( pipeline_ctrl_id_flush_o ),
        .pipeline_ctrl_ex_stall_o( pipeline_ctrl_ex_stall_o ),
        .pipeline_ctrl_ex_flush_o( pipeline_ctrl_ex_flush_o ),
        .pipeline_ctrl_ex_rs1_src_buffer_o( pipeline_ctrl_ex_rs1_src_buffer_o ),
        .pipeline_ctrl_ex_rs2_src_buffer_o( pipeline_ctrl_ex_rs2_src_buffer_o ),
        .pipeline_ctrl_ex_rs1_buffered_o( pipeline_ctrl_ex_rs1_buffered_o ),
        .pipeline_ctrl_ex_rs2_buffered_o( pipeline_ctrl_ex_rs2_buffered_o ),  
        .pipeline_ctrl_intp_en_o( pipeline_ctrl_intp_en_o ) 
    );


`ifdef DEFINE_PUTCH
    always @( posedge mem2wb_inst_selfdefine_o ) begin
        $write("%c", id_top_regs_o[10][7:0]);
    end
`endif

`ifdef DEFINE_DIFFTEST
    // Difftest
    reg cmt_wen;
    reg [7:0] cmt_wdest;
    reg [`REG_BUS] cmt_wdata;
    reg [`REG_BUS] cmt_pc;
    reg [31:0] cmt_inst;
    reg cmt_valid;
    reg trap;
    reg [7:0] trap_code;
    reg [63:0] cycleCnt;
    reg [63:0] instrCnt;
    reg [`REG_BUS] regs_diff [ 31:0 ];
    reg cmt_skip;
    // output                          csr_skip
    // reg [`REG_BUS]  cmt_mstatus;
    // reg [`REG_BUS]  cmt_mtvec;
    // reg [`REG_BUS]  cmt_mepc;
    // reg [`REG_BUS]  cmt_mcause;
    // reg [`REG_BUS]  cmt_mip;
    // reg [`REG_BUS]  cmt_mie;
    // reg [`REG_BUS]  cmt_mscratch;
    reg [31:0]      cmt_intrNO;
    reg [`REG_BUS]  cmt_einst;
    reg [`REG_BUS]  cmt_epc;
    reg             intp_r;
    reg [`INST_BUS] einst_r;
    reg [`INST_ADDR_BUS] epc_r;
    // wire inst_valid = ( inst_addr != `PC_START) | (inst != 0);
    always @(negedge clock) begin
        if (reset) begin
            {cmt_wen, cmt_wdest, cmt_wdata, cmt_pc, cmt_inst, cmt_valid, trap, trap_code, cycleCnt, instrCnt} <= 0;
        end
        else if (~trap) begin
            cmt_wen <=   mem2wb_rd_en_o & pipeline_ctrl_inst_valid_o;
            cmt_wdest <= {3'd0, mem2wb_rd_index_o};
            cmt_wdata <= mem2wb_rd_data_o;
            cmt_pc <= mem2wb_inst_addr_o;
            cmt_inst <= mem2wb_inst_o;
            cmt_valid <= pipeline_ctrl_inst_valid_o & ~mem2wb_inst_nop_o & ~mem2wb_intp_en_o;
        
        	    regs_diff <= id_top_regs_o;

            trap <= mem2wb_inst_o[6:0] == 7'h6b;
            trap_code <= id_top_regs_o[10][7:0];
            cycleCnt <= cycleCnt + 1;
            instrCnt <= instrCnt + pipeline_ctrl_inst_valid_o;
            cmt_skip <= ( mem2wb_inst_csr_o & mem2wb_csr_skip_o )
                        `ifdef DEFINE_PUTCH
                        | mem2wb_inst_selfdefine_o 
                        `endif
                        | mem2wb_clint_dstb_skip_o
                        ;
            // cmt_mstatus <= mstatus;
            // cmt_mtvec <= mtvec;
            // cmt_mepc <= mepc;
            // cmt_mcause <= mcause;
            // cmt_mip <= mip;
            // cmt_mie <= mie;
            // cmt_mscratch <= mscratch;
            cmt_intrNO <= pipeline_ctrl_inst_valid_o & mem2wb_intp_en_o ? 7: 0 ;
            cmt_einst <= pipeline_ctrl_inst_valid_o & mem2wb_intp_en_o? mem2wb_inst_o: 0;
            cmt_epc <= pipeline_ctrl_inst_valid_o & mem2wb_intp_en_o? mem2wb_inst_addr_o: 0;
        end
    end
    DifftestInstrCommit DifftestInstrCommit(
      .clock              (clock),
      .coreid             (0),
      .index              (0),
      .valid              (cmt_valid),
      .pc                 (cmt_pc),
      .instr              (cmt_inst),
      .skip               (cmt_skip ),
      .isRVC              (0),
      .scFailed           (0),
      .wen                (cmt_wen),
      .wdest              (cmt_wdest),
      .wdata              (cmt_wdata)
    );

    DifftestArchIntRegState DifftestArchIntRegState (
      .clock              (clock),
      .coreid             (0),
      .gpr_0              (regs_diff[0]),
      .gpr_1              (regs_diff[1]),
      .gpr_2              (regs_diff[2]),
      .gpr_3              (regs_diff[3]),
      .gpr_4              (regs_diff[4]),
      .gpr_5              (regs_diff[5]),
      .gpr_6              (regs_diff[6]),
      .gpr_7              (regs_diff[7]),
      .gpr_8              (regs_diff[8]),
      .gpr_9              (regs_diff[9]),
      .gpr_10             (regs_diff[10]),
      .gpr_11             (regs_diff[11]),
      .gpr_12             (regs_diff[12]),
      .gpr_13             (regs_diff[13]),
      .gpr_14             (regs_diff[14]),
      .gpr_15             (regs_diff[15]),
      .gpr_16             (regs_diff[16]),
      .gpr_17             (regs_diff[17]),
      .gpr_18             (regs_diff[18]),
      .gpr_19             (regs_diff[19]),
      .gpr_20             (regs_diff[20]),
      .gpr_21             (regs_diff[21]),
      .gpr_22             (regs_diff[22]),
      .gpr_23             (regs_diff[23]),
      .gpr_24             (regs_diff[24]),
      .gpr_25             (regs_diff[25]),
      .gpr_26             (regs_diff[26]),
      .gpr_27             (regs_diff[27]),
      .gpr_28             (regs_diff[28]),
      .gpr_29             (regs_diff[29]),
      .gpr_30             (regs_diff[30]),
      .gpr_31             (regs_diff[31])
    );
    DifftestArchEvent DifftestArchEvent(
        .clock( clock ),
        .coreid( 0 ),
        .intrNO( cmt_intrNO ),
        .cause( 0 ),
        .exceptionPC( cmt_epc ),
        .exceptionInst( cmt_einst )
    );
    DifftestTrapEvent DifftestTrapEvent(
      .clock              (clock),
      .coreid             (0),
      .valid              (trap),
      .code               (trap_code),
      .pc                 (cmt_pc),
      .cycleCnt           (cycleCnt),
      .instrCnt           (instrCnt)
    );
    DifftestCSRState DifftestCSRState(
      .clock              (clock),
      .coreid             (0),
      .priviledgeMode     (3),
      .mstatus            (mem2wb_mstatus_o),
      .sstatus            (mem2wb_mstatus_o & 64'h80000003000de122),
      .mepc               (mem2wb_mepc_o),
      .sepc               (0),
      .mtval              (0),
      .stval              (0),
      .mtvec              (mem2wb_mtvec_o),
      .stvec              (0),
      .mcause             (mem2wb_mcause_o),
      .scause             (0),
      .satp               (0),
      .mip                (0),// !!!!!
      .mie                (mem2wb_mie_o),
      .mscratch           (mem2wb_mscratch_o),
      .sscratch           (0),
      .mideleg            (0),
      .medeleg            (0)
    );
    
    DifftestArchFpRegState DifftestArchFpRegState(
      .clock              (clock),
      .coreid             (0),
      .fpr_0              (0),
      .fpr_1              (0),
      .fpr_2              (0),
      .fpr_3              (0),
      .fpr_4              (0),
      .fpr_5              (0),
      .fpr_6              (0),
      .fpr_7              (0),
      .fpr_8              (0),
      .fpr_9              (0),
      .fpr_10             (0),
      .fpr_11             (0),
      .fpr_12             (0),
      .fpr_13             (0),
      .fpr_14             (0),
      .fpr_15             (0),
      .fpr_16             (0),
      .fpr_17             (0),
      .fpr_18             (0),
      .fpr_19             (0),
      .fpr_20             (0),
      .fpr_21             (0),
      .fpr_22             (0),
      .fpr_23             (0),
      .fpr_24             (0),
      .fpr_25             (0),
      .fpr_26             (0),
      .fpr_27             (0),
      .fpr_28             (0),
      .fpr_29             (0),
      .fpr_30             (0),
      .fpr_31             (0)
    );
`endif

endmodule