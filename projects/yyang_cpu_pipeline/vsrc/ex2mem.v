`include "defines.v"
module ex2mem(
    input                       clk,
    input                       rst,

    /* id2ex control signals */
    input                       ex2mem_inst_valid_i,
    input                       ex2mem_ex_flush_i,

    /* modules control signals */
    input   [`REG_INDEX_BUS]    ex2mem_rs1_index_i,
    input   [`REG_INDEX_BUS]    ex2mem_rs2_index_i,
    input   [`REG_INDEX_BUS]    ex2mem_rd_index_i,

    input                       ex2mem_rs1_en_i,
    input                       ex2mem_rs2_en_i,
    input                       ex2mem_rd_en_i,

    input   [`CSR_INDEX_BUS]    ex2mem_csr_index_i,
    input                       ex2mem_inst_csr_i,
    input                       ex2mem_inst_load_i,
    input                       ex2mem_mem_write_i,
    input                       ex2mem_mem_read_i,
    input   [`STORE_TYPE_BUS]   ex2mem_store_type_i,
    input   [`LOAD_TYPE_BUS]    ex2mem_load_type_i,
    input                       ex2mem_csr_src_i,
    input   [`CSR_CTRL_BUS]     ex2mem_csr_ctrl_i,
    input                       ex2mem_inst_ecall_i,
    input                       ex2mem_inst_ebreak_i,
    input                       ex2mem_inst_mret_i,
    input                       ex2mem_inst_trap_i,

    `ifdef DEFINE_DIFFTEST
    input                       ex2mem_inst_nop_i,
    `endif

    `ifdef DEFINE_PUTCH
    input                       ex2mem_inst_selfdefine_i,
    `endif

    output  [`REG_INDEX_BUS]    ex2mem_rs1_index_o,
    output  [`REG_INDEX_BUS]    ex2mem_rs2_index_o,
    output  [`REG_INDEX_BUS]    ex2mem_rd_index_o,

    output                      ex2mem_rs1_en_o,
    output                      ex2mem_rs2_en_o,
    output                      ex2mem_rd_en_o,

    output  [`CSR_INDEX_BUS]    ex2mem_csr_index_o,
    output                      ex2mem_inst_csr_o,
    output                      ex2mem_inst_load_o,
    output                      ex2mem_mem_write_o,
    output                      ex2mem_mem_read_o,
    output  [`STORE_TYPE_BUS]   ex2mem_store_type_o,
    output  [`LOAD_TYPE_BUS]    ex2mem_load_type_o,
    output                      ex2mem_csr_src_o,
    output  [`CSR_CTRL_BUS]     ex2mem_csr_ctrl_o,
    output                      ex2mem_inst_ecall_o,
    output                      ex2mem_inst_ebreak_o,
    output                      ex2mem_inst_mret_o,
    output                      ex2mem_inst_trap_o,

    `ifdef DEFINE_DIFFTEST
    output                      ex2mem_inst_nop_o,
    `endif

    `ifdef DEFINE_PUTCH
    output                      ex2mem_inst_selfdefine_o,
    `endif

    /* data signals */
    input   [`REG_BUS]          ex2mem_rs1_data_i,
    input   [`REG_BUS]          ex2mem_rs2_data_i,
    input   [`DATA_BUS]         ex2mem_imm_data_i,
    input   [`DATA_BUS]         ex2mem_rd_data_i,
    input   [`INST_ADDR_BUS]    ex2mem_inst_addr_i,

    output  [`REG_BUS]          ex2mem_rs1_data_o,
    output  [`REG_BUS]          ex2mem_rs2_data_o,
    output  [`DATA_BUS]         ex2mem_imm_data_o,
    output  [`DATA_BUS]         ex2mem_rd_data_o,
    output  [`INST_ADDR_BUS]    ex2mem_inst_addr_o
);

    reg     [`REG_INDEX_BUS]    rs1_index_r;
    reg     [`REG_INDEX_BUS]    rs2_index_r;
    reg     [`REG_INDEX_BUS]    rd_index_r;
    reg     [`CSR_INDEX_BUS]    csr_index_r;

    reg                         rs1_en_r;
    reg                         rs2_en_r;
    reg                         rd_en_r;

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

    `ifdef DEFINE_DIFFTEST
    reg                         inst_nop_r;
    `endif

    `ifdef DEFINE_PUTCH
    reg                         inst_selfdefine_r;
    `endif

    reg     [`REG_BUS]          rs1_data_r;
    reg     [`REG_BUS]          rs2_data_r;
    reg     [`DATA_BUS]         imm_data_r;
    reg     [`DATA_BUS]         rd_data_r;
    reg     [`INST_ADDR_BUS]    inst_addr_r;

    wire                        flush_en;
    wire                        flow_en;

    assign ex2mem_rs1_index_o        =   rs1_index_r;
    assign ex2mem_rs2_index_o        =   rs2_index_r;
    assign ex2mem_rd_index_o         =   rd_index_r;
    assign ex2mem_csr_index_o        =   csr_index_r;


    assign ex2mem_rs1_en_o           =   rs1_en_r;
    assign ex2mem_rs2_en_o           =   rs2_en_r;
    assign ex2mem_rd_en_o            =   rd_en_r;


    assign ex2mem_inst_csr_o         =   inst_csr_r;
    assign ex2mem_inst_load_o        =   inst_load_r;
    assign ex2mem_mem_write_o        =   mem_write_r;
    assign ex2mem_mem_read_o         =   mem_read_r;
    assign ex2mem_store_type_o       =   store_type_r;
    assign ex2mem_load_type_o        =   load_type_r;
    assign ex2mem_csr_src_o          =   csr_src_r;
    assign ex2mem_csr_ctrl_o         =   csr_ctrl_r;
    assign ex2mem_inst_ecall_o       =   inst_ecall_r;
    assign ex2mem_inst_ebreak_o      =   inst_ebreak_r;
    assign ex2mem_inst_mret_o        =   inst_mret_r;
    assign ex2mem_inst_trap_o        =   inst_trap_r;

    `ifdef DEFINE_DIFFTEST
    assign ex2mem_inst_nop_o         =   inst_nop_r;
    `endif

    `ifdef DEFINE_PUTCH
    assign ex2mem_inst_selfdefine_o  =   inst_selfdefine_r;
    `endif

    assign ex2mem_rs1_data_o         =   rs1_data_r;
    assign ex2mem_rs2_data_o         =   rs2_data_r;
    assign ex2mem_imm_data_o         =   imm_data_r;
    assign ex2mem_rd_data_o          =   rd_data_r;
    assign ex2mem_inst_addr_o        =   inst_addr_r;

    assign flush_en                  =   ex2mem_ex_flush_i & ex2mem_inst_valid_i;
    assign flow_en                   =   ex2mem_inst_valid_i;

    always @( posedge clk ) begin
        if( rst ) begin
            rs1_index_r <= `REG_INDEX_SIZE'b0;
        end
        else if( flush_en ) begin
            rs1_index_r <= `REG_INDEX_SIZE'b0;
        end
        else if( flow_en ) begin
            rs1_index_r <= ex2mem_rs1_index_i;
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
        else if( flow_en ) begin
            rs2_index_r <= ex2mem_rs2_index_i;
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
        else if( flow_en ) begin
            rd_index_r <= ex2mem_rd_index_i;
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
        else if( flow_en ) begin
            csr_index_r <= ex2mem_csr_index_i;
        end
        else begin
            csr_index_r <= csr_index_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            rs1_en_r <= 1'b0;        
        end
        else if( flush_en ) begin
            rs1_en_r <= 1'b0;
        end
        else if( flow_en ) begin
            rs1_en_r <= ex2mem_rs1_en_i;
        end
        else begin
            rs1_en_r <= rs1_en_r;
        end
    end

        always @( posedge clk ) begin
        if( rst ) begin
            rs2_en_r <= 1'b0;        
        end
        else if( flush_en ) begin
            rs2_en_r <= 1'b0;
        end
        else if( flow_en ) begin
            rs2_en_r <= ex2mem_rs2_en_i;
        end
        else begin
            rs2_en_r <= rs2_en_r;
        end
    end
    
    always @( posedge clk ) begin
        if( rst ) begin
            rd_en_r <= 1'b0;        
        end
        else if( flush_en ) begin
            rd_en_r <= 1'b0;
        end
        else if( flow_en ) begin
            rd_en_r <= ex2mem_rd_en_i;
        end
        else begin
            rd_en_r <= rd_en_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            inst_csr_r <= 1'b0;   
        end
        else if( flush_en ) begin
            inst_csr_r <= 1'b0;
        end
        else if( flow_en ) begin
            inst_csr_r <= ex2mem_inst_csr_i;
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
        else if( flow_en ) begin
            inst_load_r <= ex2mem_inst_load_i;
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
        else if( flow_en ) begin
            mem_write_r <= ex2mem_mem_write_i;
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
        else if( flow_en ) begin
            mem_read_r <= ex2mem_mem_read_i;
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
        else if( flow_en ) begin
            store_type_r <= ex2mem_store_type_i;
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
        else if( flow_en ) begin
            load_type_r <= ex2mem_load_type_i;
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
        else if( flow_en ) begin
            csr_src_r <= ex2mem_csr_src_i;
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
        else if( flow_en ) begin
            csr_ctrl_r <= ex2mem_csr_ctrl_i;
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
        else if( flow_en ) begin
            inst_ecall_r <= ex2mem_inst_ecall_i;
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
        else if( flow_en ) begin
            inst_ebreak_r <= ex2mem_inst_ebreak_i;
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
        else if( flow_en ) begin
            inst_mret_r <= ex2mem_inst_mret_i;
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
        else if( flow_en ) begin
            inst_trap_r <= ex2mem_inst_trap_i;
        end
        else begin
            inst_trap_r <= inst_trap_r;
        end
    end
    `ifdef DEFINE_DIFFTEST
    always @( posedge clk ) begin
        if( rst ) begin
            inst_nop_r <= 1'b1;
        end
        else if( flush_en ) begin
            inst_nop_r <= 1'b1;
        end
        else if( flow_en ) begin
            inst_nop_r <= ex2mem_inst_nop_i;
        end
        else begin
            inst_nop_r <= inst_nop_r;
        end
    end
    `endif
    `ifdef DEFINE_PUTCH
    always @( posedge clk ) begin
        if( rst ) begin
            inst_selfdefine_r <= 1'b0;   
        end
        else if( flush_en ) begin
            inst_selfdefine_r <= 1'b0;
        end
        else if( flow_en ) begin
            inst_selfdefine_r <= ex2mem_inst_selfdefine_i;
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
        else if( flow_en ) begin
            rs1_data_r <= ex2mem_rs1_data_i;
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
        else if( flow_en ) begin
            rs2_data_r <= ex2mem_rs2_data_i;
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
        else if( flow_en ) begin
            imm_data_r <= ex2mem_imm_data_i;
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
        else if( flow_en ) begin
            rd_data_r <= ex2mem_rd_data_i;
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
        else if( flow_en ) begin
            inst_addr_r <= ex2mem_inst_addr_i;
        end
        else begin
            inst_addr_r <= inst_addr_r;
        end
    end

endmodule