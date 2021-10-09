`include "defines.v"
module mem2wb(
    input                       clk,
    input                       rst,

    /* id2ex control signals */
    input                       mem2wb_inst_valid_i,

    /* modules control signals */
    input   [`REG_INDEX_BUS]    mem2wb_rd_index_i,
    input                       mem2wb_rd_en_i,
    input                       mem2wb_inst_trap_i,
    input                       mem2wb_intp_en_i,
    `ifdef DEFINE_DIFFTEST
    input                       mem2wb_inst_csr_i,
    input   [`INST_BUS]         mem2wb_inst_i,
    input   [`INST_ADDR_BUS]    mem2wb_inst_addr_i,
    input                       mem2wb_inst_nop_i,
    input                       mem2wb_csr_skip_i,
    input   [`REG_BUS]          mem2wb_mstatus_i,
    input   [`REG_BUS]          mem2wb_mtvec_i,
    input   [`REG_BUS]          mem2wb_mepc_i,
    input   [`REG_BUS]          mem2wb_mcause_i,
    input   [`REG_BUS]          mem2wb_mip_i,
    input   [`REG_BUS]          mem2wb_mie_i,
    input   [`REG_BUS]          mem2wb_mscratch_i,
    input   [31:0]              mem2wb_cause_i,
    input                       mem2wb_clint_dstb_skip_i,
    `endif

    `ifdef DEFINE_PUTCH
    input                       mem2wb_inst_selfdefine_i,
    `endif

    output  [`REG_INDEX_BUS]    mem2wb_rd_index_o,
    output                      mem2wb_rd_en_o,
    output                      mem2wb_inst_trap_o,
    output                      mem2wb_intp_en_o,

    `ifdef DEFINE_DIFFTEST
    output                      mem2wb_inst_csr_o,
    output  [`INST_BUS]         mem2wb_inst_o,
    output  [`INST_ADDR_BUS]    mem2wb_inst_addr_o,
    output                      mem2wb_inst_nop_o,
    output                      mem2wb_csr_skip_o,
    output  [`REG_BUS]          mem2wb_mstatus_o,
    output  [`REG_BUS]          mem2wb_mtvec_o,
    output  [`REG_BUS]          mem2wb_mepc_o,
    output  [`REG_BUS]          mem2wb_mcause_o,
    output  [`REG_BUS]          mem2wb_mip_o,
    output  [`REG_BUS]          mem2wb_mie_o,
    output  [`REG_BUS]          mem2wb_mscratch_o,
    output  [31:0]              mem2wb_cause_o,
    output                      mem2wb_clint_dstb_skip_o,
    `endif

    `ifdef DEFINE_PUTCH
    output                      mem2wb_inst_selfdefine_o,
    `endif

    /* data signals */
    input   [`DATA_BUS]         mem2wb_rd_data_i,
    input   [`INST_ADDR_BUS]    mem2wb_csr_nxt_pc_i,

    output  [`DATA_BUS]         mem2wb_rd_data_o,
    output  [`INST_ADDR_BUS]    mem2wb_csr_nxt_pc_o
);

    reg     [`REG_INDEX_BUS]    rd_index_r;

    reg                         rd_en_r;
    reg                         inst_trap_r;
    reg                         intp_en_r;

    `ifdef DEFINE_DIFFTEST
    reg                         inst_csr_r;
    reg     [`INST_BUS]         inst_r;
    reg     [`INST_ADDR_BUS]    inst_addr_r;
    reg                         inst_nop_r;
    reg                         csr_skip_r;
    reg     [`REG_BUS]          mstatus_r;
    reg     [`REG_BUS]          mtvec_r;
    reg     [`REG_BUS]          mepc_r;
    reg     [`REG_BUS]          mcause_r;
    reg     [`REG_BUS]          mip_r;
    reg     [`REG_BUS]          mie_r;
    reg     [`REG_BUS]          mscratch_r;
    reg     [31:0]              cause_r;
    reg                         clint_dstb_skip_r;
    `endif

    `ifdef DEFINE_PUTCH
    reg                         inst_selfdefine_r;
    `endif

    reg     [`DATA_BUS]         rd_data_r;
    reg     [`INST_ADDR_BUS]    csr_nxt_pc_r;

    wire                        flow_en;

    assign mem2wb_rd_index_o         =   rd_index_r;
    
    assign mem2wb_rd_en_o            =   rd_en_r;
    assign mem2wb_inst_trap_o        =   inst_trap_r;
    assign mem2wb_intp_en_o          =   intp_en_r;

    `ifdef DEFINE_DIFFTEST
    assign mem2wb_inst_csr_o         =   inst_csr_r;
    assign mem2wb_inst_o             =   inst_r;
    assign mem2wb_inst_addr_o        =   inst_addr_r;
    assign mem2wb_inst_nop_o         =   inst_nop_r;
    assign mem2wb_csr_skip_o         =   csr_skip_r;
    assign mem2wb_mstatus_o          =   mstatus_r;
    assign mem2wb_mtvec_o            =   mtvec_r;
    assign mem2wb_mepc_o             =   mepc_r;
    assign mem2wb_mcause_o           =   mcause_r;
    assign mem2wb_mip_o              =   mip_r;
    assign mem2wb_mie_o              =   mie_r;
    assign mem2wb_mscratch_o         =   mscratch_r;
    assign mem2wb_cause_o            =   cause_r;
    assign mem2wb_clint_dstb_skip_o  =   clint_dstb_skip_r;
    `endif

    `ifdef DEFINE_PUTCH
    assign mem2wb_inst_selfdefine_o  =   inst_selfdefine_r;
    `endif

    assign mem2wb_rd_data_o          =   rd_data_r;
    assign mem2wb_csr_nxt_pc_o       =   csr_nxt_pc_r;

    assign flow_en                   =   mem2wb_inst_valid_i;

    always @( posedge clk ) begin
        if( rst ) begin
            rd_index_r <= `REG_INDEX_SIZE'b0;
        end
        else if( flow_en ) begin
            rd_index_r <= mem2wb_rd_index_i;
        end
        else begin
            rd_index_r <= rd_index_r;
        end
    end
    
    always @( posedge clk ) begin
        if( rst ) begin
            rd_en_r <= 1'b0;        
        end
        else if( flow_en ) begin
            rd_en_r <= mem2wb_rd_en_i;
        end
        else begin
            rd_en_r <= rd_en_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            inst_trap_r <= 1'b0;        
        end
        else if( flow_en ) begin
            inst_trap_r <= mem2wb_inst_trap_i;
        end
        else begin
            inst_trap_r <= inst_trap_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            intp_en_r <= 1'b0;        
        end
        else if( flow_en ) begin
            intp_en_r <= mem2wb_intp_en_i;
        end
        else begin
            intp_en_r <= intp_en_r;
        end
    end

    `ifdef DEFINE_DIFFTEST
    always @( posedge clk ) begin
        if( rst ) begin
            inst_csr_r <= 1'b0;
        end
        else if( flow_en ) begin
            inst_csr_r <= mem2wb_inst_csr_i;
        end
        else begin
            inst_csr_r <= inst_csr_r;
        end
    end
    always @( posedge clk ) begin
        if( rst ) begin
            inst_r <= `INST_NOP;
        end
        else if( flow_en ) begin
            inst_r <= mem2wb_inst_i;
        end
        else begin
            inst_r <= inst_r;
        end
    end
    always @( posedge clk ) begin
        if( rst ) begin
            inst_addr_r <= 54'b0;
        end
        else if( flow_en ) begin
            inst_addr_r <= mem2wb_inst_addr_i;
        end
        else begin
            inst_addr_r <= inst_addr_r;
        end
    end
    always @( posedge clk ) begin
        if( rst ) begin
            inst_nop_r <= 1'b1;
        end
        else if( flow_en ) begin
            inst_nop_r <= mem2wb_inst_nop_i;
        end
        else begin
            inst_nop_r <= inst_nop_r;
        end
    end
    always @( posedge clk ) begin
        if( rst ) begin
            csr_skip_r <= 1'b0;
        end
        else if( flow_en ) begin
            csr_skip_r <= mem2wb_csr_skip_i;
        end
        else begin
            csr_skip_r <= csr_skip_r;
        end
    end
    always @( posedge clk ) begin
        if( rst ) begin
            mstatus_r <= 64'b0;
        end
        else if( flow_en ) begin
            mstatus_r <= mem2wb_mstatus_i;
        end
        else begin
            mstatus_r <= mstatus_r;
        end
    end
    always @( posedge clk ) begin
        if( rst ) begin
            mtvec_r <= 64'b0;
        end
        else if( flow_en ) begin
            mtvec_r <= mem2wb_mtvec_i;
        end
        else begin
            mtvec_r <= mtvec_r;
        end
    end
    always @( posedge clk ) begin
        if( rst ) begin
            mepc_r <= 64'b0;
        end
        else if( flow_en ) begin
            mepc_r <= mem2wb_mepc_i;
        end
        else begin
            mepc_r <= mepc_r;
        end
    end
    always @( posedge clk ) begin
        if( rst ) begin
            mcause_r <= 64'b0;
        end
        else if( flow_en ) begin
            mcause_r <= mem2wb_mcause_i;
        end
        else begin
            mcause_r <= mcause_r;
        end
    end
    always @( posedge clk ) begin
        if( rst ) begin
            mip_r <= 64'b0;
        end
        else if( flow_en ) begin
            mip_r <= mem2wb_mip_i;
        end
        else begin
            mip_r <= mip_r;
        end
    end
    always @( posedge clk ) begin
        if( rst ) begin
            mie_r <= 64'b0;
        end
        else if( flow_en ) begin
            mie_r <= mem2wb_mie_i;
        end
        else begin
            mie_r <= mie_r;
        end
    end
    always @( posedge clk ) begin
        if( rst ) begin
            mscratch_r <= 64'b0;
        end
        else if( flow_en ) begin
            mscratch_r <= mem2wb_mscratch_i;
        end
        else begin
            mscratch_r <= mscratch_r;
        end
    end
    always @( posedge clk ) begin
        if( rst ) begin
            cause_r <= 32'b0;
        end
        else if( flow_en ) begin
            cause_r <= mem2wb_cause_i;
        end
        else begin
            cause_r <= cause_r;
        end
    end
    `endif

    `ifdef DEFINE_PUTCH
    always @( posedge clk ) begin
        if( rst ) begin
            inst_selfdefine_r <= 1'b0;   
        end
        else if( flow_en ) begin
            inst_selfdefine_r <= mem2wb_inst_selfdefine_i;
        end
        else begin
            inst_selfdefine_r <= inst_selfdefine_r;
        end
    end
    `endif

    always @( posedge clk ) begin
        if( rst ) begin
            rd_data_r <= 64'b0;   
        end
        else if( flow_en ) begin
            rd_data_r <= mem2wb_rd_data_i;
        end
        else begin
            rd_data_r <= rd_data_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            csr_nxt_pc_r <= 64'b0;   
        end
        else if( flow_en ) begin
            csr_nxt_pc_r <= mem2wb_csr_nxt_pc_i;
        end
        else begin
            csr_nxt_pc_r <= csr_nxt_pc_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            clint_dstb_skip_r <= 1'b0;   
        end
        else if( flow_en ) begin
            clint_dstb_skip_r <= mem2wb_clint_dstb_skip_i;
        end
        else begin
            clint_dstb_skip_r <= clint_dstb_skip_r;
        end
    end

endmodule