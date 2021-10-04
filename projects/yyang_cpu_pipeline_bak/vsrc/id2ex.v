`include "defines.v"
module id2ex(
    input                       clk,
    input                       rst,

    /* id2ex control signals */
    input                       id2ex_inst_valid_i,
    input                       id2ex_id_flush_i,
    input                       id2ex_ex_stall_i,
    /* modules control signals */
    input  [`REG_INDEX_BUS]     id2ex_rs1_index_i,
    input  [`REG_INDEX_BUS]     id2ex_rs2_index_i,
    input  [`REG_INDEX_BUS]     id2ex_rd_index_i,
    input  [`CSR_INDEX_BUS]     id2ex_csr_index_i,

    input                       id2ex_inst_nop_i,

    input                       id2ex_rd_en_i,
    input                       id2ex_inst_jump_i,
    input                       id2ex_inst_branch_i,

    input                       id2ex_inst_word_i,
    input                       id2ex_inst_slt_nu_i,
    input                       id2ex_inst_slt_u_i,
    input                       id2ex_inst_shift_i,
    input                       id2ex_alu_src_pc_i,
    input                       id2ex_alu_src_imm_i,
    input                       id2ex_shift_num_src_i,
    input  [`SHIFT_TYPE_BUS]    id2ex_shift_type_i,
    input                       id2ex_inst_arth_lgc_i,
    input                       id2ex_inst_auipc_i,
    input  [`ALU_OP_BUS]        id2ex_alu_op_i,

    input                       id2ex_inst_csr_i,
    input                       id2ex_inst_load_i,
    input                       id2ex_mem_write_i,
    input                       id2ex_mem_read_i,
    input  [`STORE_TYPE_BUS]    id2ex_store_type_i,
    input  [`LOAD_TYPE_BUS]     id2ex_load_type_i,
    input                       id2ex_csr_src_i,
    input  [`CSR_CTRL_BUS]      id2ex_csr_ctrl_i,
    input                       id2ex_inst_ecall_i,
    input                       id2ex_inst_ebreak_i,
    input                       id2ex_inst_mret_i,
    input                       id2ex_inst_trap_i,

    input                       id2ex_jumpbranch_en_i,

    `ifdef DEFINE_PUTCH
    input                       id2ex_inst_selfdefine_i,
    `endif
    output  [`REG_INDEX_BUS]    id2ex_rs1_index_o,
    output  [`REG_INDEX_BUS]    id2ex_rs2_index_o,
    output  [`REG_INDEX_BUS]    id2ex_rd_index_o,
    output  [`CSR_INDEX_BUS]    id2ex_csr_index_o,

    output                      id2ex_inst_nop_o,

    output                      id2ex_rd_en_o,
    output                      id2ex_inst_jump_o,
    output                      id2ex_inst_branch_o,

    output                      id2ex_inst_word_o,
    output                      id2ex_inst_slt_nu_o,
    output                      id2ex_inst_slt_u_o,
    output                      id2ex_inst_shift_o,
    output                      id2ex_alu_src_pc_o,
    output                      id2ex_alu_src_imm_o,
    output                      id2ex_shift_num_src_o,
    output  [`SHIFT_TYPE_BUS]   id2ex_shift_type_o,
    output                      id2ex_inst_arth_lgc_o,
    output                      id2ex_inst_auipc_o,
    output  [`ALU_OP_BUS]       id2ex_alu_op_o,

    output                      id2ex_inst_csr_o,
    output                      id2ex_inst_load_o,
    output                      id2ex_mem_write_o,
    output                      id2ex_mem_read_o,
    output  [`STORE_TYPE_BUS]   id2ex_store_type_o,
    output  [`LOAD_TYPE_BUS]    id2ex_load_type_o,
    output                      id2ex_csr_src_o,
    output  [`CSR_CTRL_BUS]     id2ex_csr_ctrl_o,
    output                      id2ex_inst_ecall_o,
    output                      id2ex_inst_ebreak_o,
    output                      id2ex_inst_mret_o,
    output                      id2ex_inst_trap_o,

    output                      id2ex_jumpbranch_en_o,

    `ifdef DEFINE_PUTCH
    output                      id2ex_inst_selfdefine_o,
    `endif

    /* data signals */
    input  [`REG_BUS]           id2ex_rs1_data_i,
    input  [`REG_BUS]           id2ex_rs2_data_i,
    input  [`DATA_BUS]          id2ex_imm_data_i,
    input  [`DATA_BUS]          id2ex_rd_data_i,
    input  [`INST_ADDR_BUS]     id2ex_inst_addr_i,
    input  [`INST_ADDR_BUS]     id2ex_jumpbranch_addr_i,

    output  [`REG_BUS]          id2ex_rs1_data_o,
    output  [`REG_BUS]          id2ex_rs2_data_o,
    output  [`DATA_BUS]         id2ex_imm_data_o,
    output  [`DATA_BUS]         id2ex_rd_data_o,
    output  [`INST_ADDR_BUS]    id2ex_inst_addr_o,
    output  [`INST_ADDR_BUS]    id2ex_jumpbranch_addr_o
);

    reg     [`REG_INDEX_BUS]    rs1_index_r;
    reg     [`REG_INDEX_BUS]    rs2_index_r;
    reg     [`REG_INDEX_BUS]    rd_index_r;
    reg     [`CSR_INDEX_BUS]    csr_index_r;

    reg                         inst_nop_r;

    reg                         rd_en_r;
    reg                         inst_jump_r;
    reg                         inst_branch_r;

    reg                         inst_word_r;
    reg                         inst_slt_nu_r;
    reg                         inst_slt_u_r;
    reg                         inst_shift_r;
    reg                         alu_src_pc_r;
    reg                         alu_src_imm_r;
    reg                         shift_num_src_r;
    reg     [`SHIFT_TYPE_BUS]   shift_type_r;
    reg                         inst_arth_lgc_r;
    reg                         inst_auipc_r;
    reg     [`ALU_OP_BUS]       alu_op_r;

    reg                         inst_csr_r;
    reg                         inst_load_r;
    reg                         mem_write_r;
    reg                         mem_read_r;
    reg     [`STORE_TYPE_BUS]   store_type_r;
    reg     [`LOAD_TYPE_BUS]    load_type_r;
    reg                         csr_src_r;
    reg     [`CSR_CTRL_BUS]     csr_ctrl_r;
    reg                         inst_ecall_r;
    reg                         inst_ebreak_r;
    reg                         inst_mret_r;
    reg                         inst_trap_r;

    reg                         jumpbranch_en_r;

    `ifdef DEFINE_PUTCH
    reg                         inst_selfdefine_r;
    `endif

    reg     [`REG_BUS]          rs1_data_r;
    reg     [`REG_BUS]          rs2_data_r;
    reg     [`DATA_BUS]         imm_data_r;
    reg     [`DATA_BUS]         rd_data_r;
    reg     [`INST_ADDR_BUS]    inst_addr_r;
    reg     [`INST_ADDR_BUS]    jumpbranch_addr_r;

    wire                        flush_en;
    wire                        stall_en;
    wire                        flow_en;

    assign id2ex_rs1_index_o        =   rs1_index_r;
    assign id2ex_rs2_index_o        =   rs2_index_r;
    assign id2ex_rd_index_o         =   rd_index_r;
    assign id2ex_csr_index_o        =   csr_index_r;

    assign id2ex_inst_nop_o         =   inst_nop_r;

    assign id2ex_rd_en_o            =   rd_en_r;
    assign id2ex_inst_jump_o        =   inst_jump_r;
    assign id2ex_inst_branch_o      =   inst_branch_r;

    assign id2ex_inst_word_o        =   inst_word_r;
    assign id2ex_inst_slt_nu_o      =   inst_slt_nu_r;
    assign id2ex_inst_slt_u_o       =   inst_slt_u_r;
    assign id2ex_inst_shift_o       =   inst_shift_r;
    assign id2ex_alu_src_pc_o       =   alu_src_pc_r;
    assign id2ex_alu_src_imm_o      =   alu_src_imm_r;
    assign id2ex_shift_num_src_o    =   shift_num_src_r;
    assign id2ex_shift_type_o       =   shift_type_r;
    assign id2ex_inst_arth_lgc_o    =   inst_arth_lgc_r;   
    assign id2ex_inst_auipc_o       =   inst_auipc_r;
    assign id2ex_alu_op_o           =   alu_op_r;

    assign id2ex_inst_csr_o         =   inst_csr_r;
    assign id2ex_inst_load_o        =   inst_load_r;
    assign id2ex_mem_write_o        =   mem_write_r;
    assign id2ex_mem_read_o         =   mem_read_r;
    assign id2ex_store_type_o       =   store_type_r;
    assign id2ex_load_type_o        =   load_type_r;
    assign id2ex_csr_src_o          =   csr_src_r;
    assign id2ex_csr_ctrl_o         =   csr_ctrl_r;
    assign id2ex_inst_ecall_o       =   inst_ecall_r;
    assign id2ex_inst_ebreak_o      =   inst_ebreak_r;
    assign id2ex_inst_mret_o        =   inst_mret_r;
    assign id2ex_inst_trap_o        =   inst_trap_r;

    assign id2ex_jumpbranch_en_o    =   jumpbranch_en_r;

    `ifdef DEFINE_PUTCH
    assign id2ex_inst_selfdefine_o  =   inst_selfdefine_r;
    `endif

    assign id2ex_rs1_data_o         =   rs1_data_r;
    assign id2ex_rs2_data_o         =   rs2_data_r;
    assign id2ex_imm_data_o         =   imm_data_r;
    assign id2ex_rd_data_o          =   rd_data_r;
    assign id2ex_inst_addr_o        =   inst_addr_r;
    assign id2ex_jumpbranch_addr_o  =   jumpbranch_addr_r;

    assign flush_en                 =   id2ex_id_flush_i & id2ex_inst_valid_i;
    assign stall_en                 =   id2ex_ex_stall_i & id2ex_inst_valid_i;
    assign flow_en                  =   id2ex_inst_valid_i;

    always @( posedge clk ) begin
        if( rst ) begin
            rs1_index_r <= `REG_INDEX_SIZE'b0;
        end
        else if( flush_en ) begin
            rs1_index_r <= `REG_INDEX_SIZE'b0;
        end
        else if( stall_en ) begin
            rs1_index_r <= rs1_index_r;
        end
        else if( flow_en ) begin
            rs1_index_r <= id2ex_rs1_index_i;
        end
        else begin
            rs1_index_r <= rs1_index_r;
        end
    end
    
    always @( posedge clk ) begin
        if( rst ) begin
            rs2_index_r <= `REG_INDEX_SIZE'b0;
        end
        else if( flush_en ) begin
            rs2_index_r <= `REG_INDEX_SIZE'b0;
        end
        else if( stall_en ) begin
            rs2_index_r <= rs2_index_r;
        end
        else if( flow_en ) begin
            rs2_index_r <= id2ex_rs2_index_i;
        end
        else begin
            rs2_index_r <= rs2_index_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            rd_index_r <= `REG_INDEX_SIZE'b0;
        end
        else if( flush_en ) begin
            rd_index_r <= `REG_INDEX_SIZE'b0;
        end
        else if( stall_en ) begin
            rd_index_r <= rd_index_r;
        end
        else if( flow_en ) begin
            rd_index_r <= id2ex_rd_index_i;
        end
        else begin
            rd_index_r <= rd_index_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            csr_index_r <= `CSR_INDEX_SIZE'b0;
        end
        else if( flush_en ) begin
            csr_index_r <= `CSR_INDEX_SIZE'b0;
        end
        else if( stall_en ) begin
            csr_index_r <= csr_index_r;
        end
        else if( flow_en ) begin
            csr_index_r <= id2ex_csr_index_i;
        end
        else begin
            csr_index_r <= csr_index_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            inst_nop_r <= 1'b1;
        end
        else if( flush_en ) begin
            inst_nop_r <= 1'b1;
        end
        else if( stall_en ) begin
            inst_nop_r <= inst_nop_r;
        end
        else if( flow_en ) begin
            inst_nop_r <= id2ex_inst_nop_i;
        end
        else begin
            inst_nop_r <= inst_nop_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            rd_en_r <= 1'b0;        
        end
        else if( flush_en ) begin
            rd_en_r <= 1'b0;
        end
        else if( stall_en ) begin
            rd_en_r <= rd_en_r;
        end
        else if( flow_en ) begin
            rd_en_r <= id2ex_rd_en_i;
        end
        else begin
            rd_en_r <= rd_en_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            inst_jump_r <= 1'b0;        
        end
        else if( flush_en ) begin
            inst_jump_r <= 1'b0;
        end
        else if( stall_en ) begin
            inst_jump_r <= inst_jump_r;
        end
        else if( flow_en ) begin
            inst_jump_r <= id2ex_inst_jump_i;
        end
        else begin
            inst_jump_r <= inst_jump_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            inst_branch_r <= 1'b0;
        end
        else if( flush_en ) begin
            inst_branch_r <= 1'b0;
        end
        else if( stall_en ) begin
            inst_branch_r <= inst_branch_r;
        end
        else if( flow_en ) begin
            inst_branch_r <= id2ex_inst_branch_i;
        end
        else begin
            inst_branch_r <= inst_branch_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            inst_word_r <= 1'b0;   
        end
        else if( flush_en ) begin
            inst_word_r <= 1'b0;
        end
        else if( stall_en ) begin
            inst_word_r <= inst_word_r;
        end
        else if( flow_en ) begin
            inst_word_r <= id2ex_inst_word_i;
        end
        else begin
            inst_word_r <= inst_word_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            inst_slt_nu_r <= 1'b0;   
        end
        else if( flush_en ) begin
            inst_slt_nu_r <= 1'b0;
        end
        else if( stall_en ) begin
            inst_slt_nu_r <= inst_slt_nu_r;
        end
        else if( flow_en ) begin
            inst_slt_nu_r <= id2ex_inst_slt_nu_i;
        end
        else begin
            inst_slt_nu_r <= inst_slt_nu_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            inst_slt_u_r <= 1'b0;   
        end
        else if( flush_en ) begin
            inst_slt_u_r <= 1'b0;
        end
        else if( stall_en ) begin
            inst_slt_u_r <= inst_slt_u_r;
        end
        else if( flow_en ) begin
            inst_slt_u_r <= id2ex_inst_slt_u_i;
        end
        else begin
            inst_slt_u_r <= inst_slt_u_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            inst_shift_r <= 1'b0;   
        end
        else if( flush_en ) begin
            inst_shift_r <= 1'b0;
        end
        else if( stall_en ) begin
            inst_shift_r <= inst_shift_r;
        end
        else if( flow_en ) begin
            inst_shift_r <= id2ex_inst_shift_i;
        end
        else begin
            inst_shift_r <= inst_shift_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            alu_src_pc_r <= 1'b1;   
        end
        else if( flush_en ) begin
            alu_src_pc_r <= 1'b1;
        end
        else if( stall_en ) begin
            alu_src_pc_r <= alu_src_pc_r;
        end
        else if( flow_en ) begin
            alu_src_pc_r <= id2ex_alu_src_pc_i;
        end
        else begin
            alu_src_pc_r <= alu_src_pc_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            alu_src_imm_r <= 1'b0;   
        end
        else if( flush_en ) begin
            alu_src_imm_r <= 1'b0;
        end
        else if( stall_en ) begin
            alu_src_imm_r <= alu_src_imm_r;
        end
        else if( flow_en ) begin
            alu_src_imm_r <= id2ex_alu_src_imm_i;
        end
        else begin
            alu_src_imm_r <= alu_src_imm_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            shift_num_src_r <= 1'b0;   
        end
        else if( flush_en ) begin
            shift_num_src_r <= 1'b0;
        end
        else if( stall_en ) begin
            shift_num_src_r <= shift_num_src_r;
        end
        else if( flow_en ) begin
            shift_num_src_r <= id2ex_shift_num_src_i;
        end
        else begin
            shift_num_src_r <= shift_num_src_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            shift_type_r <= 3'b0;   
        end
        else if( flush_en ) begin
            shift_type_r <= 3'b0;
        end
        else if( stall_en ) begin
            shift_type_r <= shift_type_r;
        end
        else if( flow_en ) begin
            shift_type_r <= id2ex_shift_type_i;
        end
        else begin
            shift_type_r <= shift_type_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            inst_arth_lgc_r <= 1'b0;   
        end
        else if( flush_en ) begin
            inst_arth_lgc_r <= 1'b0;
        end
        else if( stall_en ) begin
            inst_arth_lgc_r <= inst_arth_lgc_r;
        end
        else if( flow_en ) begin
            inst_arth_lgc_r <= id2ex_inst_arth_lgc_i;
        end
        else begin
            inst_arth_lgc_r <= inst_arth_lgc_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            inst_auipc_r <= 1'b0;   
        end
        else if( flush_en ) begin
            inst_auipc_r <= 1'b0;
        end
        else if( stall_en ) begin
            inst_auipc_r <= inst_auipc_r;
        end
        else if( flow_en ) begin
            inst_auipc_r <= id2ex_inst_auipc_i;
        end
        else begin
            inst_auipc_r <= inst_auipc_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            alu_op_r <= 3'b0;   
        end
        else if( flush_en ) begin
            alu_op_r <= 3'b0;
        end
        else if( stall_en ) begin
            alu_op_r <= alu_op_r;
        end
        else if( flow_en ) begin
            alu_op_r <= id2ex_alu_op_i;
        end
        else begin
            alu_op_r <= alu_op_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            inst_csr_r <= 1'b0;   
        end
        else if( flush_en ) begin
            inst_csr_r <= 1'b0;
        end
        else if( stall_en ) begin
            inst_csr_r <= inst_csr_r;
        end
        else if( flow_en ) begin
            inst_csr_r <= id2ex_inst_csr_i;
        end
        else begin
            inst_csr_r <= inst_csr_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            inst_load_r <= 1'b0;   
        end
        else if( flush_en ) begin
            inst_load_r <= 1'b0;
        end
        else if( stall_en ) begin
            inst_load_r <= inst_load_r;
        end
        else if( flow_en ) begin
            inst_load_r <= id2ex_inst_load_i;
        end
        else begin
            inst_load_r <= inst_load_r;
        end
    end 

    always @( posedge clk ) begin
        if( rst ) begin
            mem_write_r <= 1'b0;   
        end
        else if( flush_en ) begin
            mem_write_r <= 1'b0;
        end
        else if( stall_en ) begin
            mem_write_r <= mem_write_r;
        end
        else if( flow_en ) begin
            mem_write_r <= id2ex_mem_write_i;
        end
        else begin
            mem_write_r <= mem_write_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            mem_read_r <= 1'b0;   
        end
        else if( flush_en ) begin
            mem_read_r <= 1'b0;
        end
        else if( stall_en ) begin
            mem_read_r <= mem_read_r;
        end
        else if( flow_en ) begin
            mem_read_r <= id2ex_mem_read_i;
        end
        else begin
            mem_read_r <= mem_read_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            store_type_r <= 3'b0;   
        end
        else if( flush_en ) begin
            store_type_r <= 3'b0;
        end
        else if( stall_en ) begin
            store_type_r <= store_type_r;
        end
        else if( flow_en ) begin
            store_type_r <= id2ex_store_type_i;
        end
        else begin
            store_type_r <= store_type_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            load_type_r <= 3'b0;   
        end
        else if( flush_en ) begin
            load_type_r <= 3'b0;
        end
        else if( stall_en ) begin
            load_type_r <= load_type_r;
        end
        else if( flow_en ) begin
            load_type_r <= id2ex_load_type_i;
        end
        else begin
            load_type_r <= load_type_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            csr_src_r <= 1'b0;   
        end
        else if( flush_en ) begin
            csr_src_r <= 1'b0;
        end
        else if( stall_en ) begin
            csr_src_r <= csr_src_r;
        end
        else if( flow_en ) begin
            csr_src_r <= id2ex_csr_src_i;
        end
        else begin
            csr_src_r <= csr_src_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            csr_ctrl_r <= 3'b0;   
        end
        else if( flush_en ) begin
            csr_ctrl_r <= 3'b0;
        end
        else if( stall_en ) begin
            csr_ctrl_r <= csr_ctrl_r;
        end
        else if( flow_en ) begin
            csr_ctrl_r <= id2ex_csr_ctrl_i;
        end
        else begin
            csr_ctrl_r <= csr_ctrl_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            inst_ecall_r <= 1'b0;   
        end
        else if( flush_en ) begin
            inst_ecall_r <= 1'b0;
        end
        else if( stall_en ) begin
            inst_ecall_r <= inst_ecall_r;
        end
        else if( flow_en ) begin
            inst_ecall_r <= id2ex_inst_ecall_i;
        end
        else begin
            inst_ecall_r <= inst_ecall_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            inst_ebreak_r <= 1'b0;   
        end
        else if( flush_en ) begin
            inst_ebreak_r <= 1'b0;
        end
        else if( stall_en ) begin
            inst_ebreak_r <= inst_ebreak_r;
        end
        else if( flow_en ) begin
            inst_ebreak_r <= id2ex_inst_ebreak_i;
        end
        else begin
            inst_ebreak_r <= inst_ebreak_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            inst_mret_r <= 1'b0;   
        end
        else if( flush_en ) begin
            inst_mret_r <= 1'b0;
        end
        else if( stall_en ) begin
            inst_mret_r <= inst_mret_r;
        end
        else if( flow_en ) begin
            inst_mret_r <= id2ex_inst_mret_i;
        end
        else begin
            inst_mret_r <= inst_mret_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            inst_trap_r <= 1'b0;   
        end
        else if( flush_en ) begin
            inst_trap_r <= 1'b0;
        end
        else if( stall_en ) begin
            inst_trap_r <= inst_trap_r;
        end
        else if( flow_en ) begin
            inst_trap_r <= id2ex_inst_trap_i;
        end
        else begin
            inst_trap_r <= inst_trap_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            jumpbranch_en_r <= 1'b0;   
        end
        else if( flush_en ) begin
            jumpbranch_en_r <= 1'b0;
        end
        else if( stall_en ) begin
            jumpbranch_en_r <= jumpbranch_en_r;
        end
        else if( flow_en ) begin
            jumpbranch_en_r <= id2ex_jumpbranch_en_i;
        end
        else begin
            jumpbranch_en_r <= jumpbranch_en_r;
        end
    end

    `ifdef DEFINE_PUTCH
    always @( posedge clk ) begin
        if( rst ) begin
            inst_selfdefine_r <= 1'b0;   
        end
        else if( flush_en ) begin
            inst_selfdefine_r <= 1'b0;
        end
        else if( stall_en ) begin
            inst_selfdefine_r <= inst_selfdefine_r;
        end
        else if( flow_en ) begin
            inst_selfdefine_r <= id2ex_inst_selfdefine_i;
        end
        else begin
            inst_selfdefine_r <= inst_selfdefine_r;
        end
    end
    `endif

    always @( posedge clk ) begin
        if( rst ) begin
            rs1_data_r <= 64'b0;   
        end
        else if( flush_en ) begin
            rs1_data_r <= 64'b0;
        end
        else if( stall_en ) begin
            rs1_data_r <= rs1_data_r;
        end
        else if( flow_en ) begin
            rs1_data_r <= id2ex_rs1_data_i;
        end
        else begin
            rs1_data_r <= rs1_data_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            rs2_data_r <= 64'b0;   
        end
        else if( flush_en ) begin
            rs2_data_r <= 64'b0;
        end
        else if( stall_en ) begin
            rs2_data_r <= rs2_data_r;
        end
        else if( flow_en ) begin
            rs2_data_r <= id2ex_rs2_data_i;
        end
        else begin
            rs2_data_r <= rs2_data_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            imm_data_r <= 64'b0;   
        end
        else if( flush_en ) begin
            imm_data_r <= 64'b0;
        end
        else if( stall_en ) begin
            imm_data_r <= imm_data_r;
        end
        else if( flow_en ) begin
            imm_data_r <= id2ex_imm_data_i;
        end
        else begin
            imm_data_r <= imm_data_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            rd_data_r <= 64'b0;   
        end
        else if( flush_en ) begin
            rd_data_r <= 64'b0;
        end
        else if( stall_en ) begin
            rd_data_r <= rd_data_r;
        end
        else if( flow_en ) begin
            rd_data_r <= id2ex_rd_data_i;
        end
        else begin
            rd_data_r <= rd_data_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            inst_addr_r <= 64'b0;   
        end
        else if( flush_en ) begin
            inst_addr_r <= 64'b0;
        end
        else if( stall_en ) begin
            inst_addr_r <= inst_addr_r;
        end
        else if( flow_en ) begin
            inst_addr_r <= id2ex_inst_addr_i;
        end
        else begin
            inst_addr_r <= inst_addr_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            jumpbranch_addr_r <= 64'b0;   
        end
        else if( flush_en ) begin
            jumpbranch_addr_r <= 64'b0;
        end
        else if( stall_en ) begin
            jumpbranch_addr_r <= jumpbranch_addr_r;
        end
        else if( flow_en ) begin
            jumpbranch_addr_r <= id2ex_jumpbranch_addr_i;
        end
        else begin
            jumpbranch_addr_r <= jumpbranch_addr_r;
        end
    end

endmodule