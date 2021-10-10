`include "defines.v"
module pipeline_ctrl(
    input                       clk,
    input                       rst,

    input                       pipeline_ctrl_fetched_ok_i,

    input                       pipeline_ctrl_id_inst_branch_i,
    input                       pipeline_ctrl_id_inst_jump_i,
    input                       pipeline_ctrl_id_inst_trap_i,
    input                       pipeline_ctrl_id_rs1_src_id2ex_i,
    input                       pipeline_ctrl_id_rs1_src_ex2mem_i,
    input                       pipeline_ctrl_id_rs2_src_id2ex_i,
    input                       pipeline_ctrl_id_rs2_src_ex2mem_i,

    input                       pipeline_ctrl_id2ex_inst_branch_i,
    input                       pipeline_ctrl_id2ex_inst_jump_i,
    input                       pipeline_ctrl_id2ex_inst_trap_i,
    input                       pipeline_ctrl_id2ex_inst_load_i,
    input                       pipeline_ctrl_id2ex_inst_csr_i,
    input                       pipeline_ctrl_id2ex_inst_arth_lgc_i,
    input                       pipeline_ctrl_id2ex_inst_auipc_i,
    input                       pipeline_ctrl_ex_rs1_src_ex2mem_i,
    input                       pipeline_ctrl_ex_rs2_src_ex2mem_i,
    input                       pipeline_ctrl_ex_rs1_src_mem2wb_i,
    input                       pipeline_ctrl_ex_rs2_src_mem2wb_i,

    input                       pipeline_ctrl_access_ok_i,
    input                       pipeline_ctrl_mem_csr_trap_i,
    input                       pipeline_ctrl_ex2mem_inst_nop_i,
    input                       pipeline_ctrl_ex2mem_inst_trap_i,
    input                       pipeline_ctrl_ex2mem_inst_load_i,
    input                       pipeline_ctrl_ex2mem_mem_read_i,
    input                       pipeline_ctrl_ex2mem_mem_write_i,
    input                       pipeline_ctrl_ex2mem_inst_csr_i,

    input                       pipeline_ctrl_mem2wb_inst_trap_i,
    input                       pipeline_ctrl_mem2wb_intp_en_i,


    output                      pipeline_ctrl_inst_valid_o,

    output                      pipeline_ctrl_dont_fetch_o,
    output                      pipeline_ctrl_if_flush_o,
    output                      pipeline_ctrl_id_stall_o,
    output                      pipeline_ctrl_id_flush_o,
    output                      pipeline_ctrl_ex_stall_o,
    output                      pipeline_ctrl_ex_flush_o,
    
    output                      pipeline_ctrl_ex_rs1_src_buffer_o,
    output                      pipeline_ctrl_ex_rs2_src_buffer_o,
    output                      pipeline_ctrl_ex_rs1_buffered_o,
    output                      pipeline_ctrl_ex_rs2_buffered_o,  
    output                      pipeline_ctrl_intp_en_o 
);
    wire                        mem_access;
    wire                        id_rsx_src_id2ex;
    wire                        id_rsx_src_ex2mem;
    wire                        ex_rsx_src_ex2mem;
    wire                        id2ex_load_csr;
    wire                        ex2mem_load_csr;
    wire                        intp_en;
    wire                        if_trap_flush;
    wire                        if_jumpbranch_flush;
    reg                         ex_rs1_src_buffered_r;
    reg                         ex_rs2_src_buffered_r;
    reg                         intp_en_r;

    assign mem_access                               =   pipeline_ctrl_ex2mem_mem_read_i | pipeline_ctrl_ex2mem_mem_write_i;
    assign id_rsx_src_id2ex                         =   pipeline_ctrl_id_rs1_src_id2ex_i | pipeline_ctrl_id_rs2_src_id2ex_i;
    assign id_rsx_src_ex2mem                        =   pipeline_ctrl_id_rs1_src_ex2mem_i | pipeline_ctrl_id_rs2_src_ex2mem_i;
    assign ex_rsx_src_ex2mem                        =   pipeline_ctrl_ex_rs1_src_ex2mem_i | pipeline_ctrl_ex_rs2_src_ex2mem_i;
    assign id2ex_load_csr                           =   pipeline_ctrl_id2ex_inst_load_i | pipeline_ctrl_id2ex_inst_csr_i;
    assign ex2mem_load_csr                          =   pipeline_ctrl_ex2mem_inst_load_i | pipeline_ctrl_ex2mem_inst_csr_i;
    assign intp_en                                  =   pipeline_ctrl_intp_en_o | pipeline_ctrl_mem2wb_intp_en_i;
    assign if_trap_flush                            =   pipeline_ctrl_id_inst_trap_i | pipeline_ctrl_id2ex_inst_trap_i 
                                                        | pipeline_ctrl_ex2mem_inst_trap_i | pipeline_ctrl_mem2wb_inst_trap_i 
                                                        | intp_en;
    assign if_jumpbranch_flush                        =   pipeline_ctrl_id_inst_jump_i | pipeline_ctrl_id_inst_branch_i | pipeline_ctrl_id2ex_inst_jump_i
                                                        | pipeline_ctrl_id2ex_inst_branch_i;

    assign pipeline_ctrl_inst_valid_o               =   pipeline_ctrl_fetched_ok_i & ( ~mem_access | ( mem_access & pipeline_ctrl_access_ok_i ) );
    assign pipeline_ctrl_dont_fetch_o               =   pipeline_ctrl_if_flush_o | pipeline_ctrl_id_stall_o;
    assign pipeline_ctrl_if_flush_o                 =   if_trap_flush | ( if_jumpbranch_flush & ~pipeline_ctrl_id_stall_o );
    assign pipeline_ctrl_id_stall_o                 =   pipeline_ctrl_ex_stall_o | ( id_rsx_src_id2ex & ( pipeline_ctrl_id2ex_inst_arth_lgc_i | pipeline_ctrl_id2ex_inst_auipc_i | id2ex_load_csr ) )
                                                        | ( id_rsx_src_ex2mem & ex2mem_load_csr );
    assign pipeline_ctrl_id_flush_o                 =   intp_en | ( pipeline_ctrl_id_stall_o & ~pipeline_ctrl_ex_stall_o );
    assign pipeline_ctrl_ex_stall_o                 =   ex_rsx_src_ex2mem & ex2mem_load_csr;
    assign pipeline_ctrl_ex_flush_o                 =   intp_en | pipeline_ctrl_ex_stall_o;
    assign pipeline_ctrl_ex_rs1_src_buffer_o        =   ex_rs1_src_buffered_r;
    assign pipeline_ctrl_ex_rs2_src_buffer_o        =   ex_rs2_src_buffered_r;           

    assign pipeline_ctrl_intp_en_o                  =   intp_en_r;

    assign pipeline_ctrl_ex_rs1_buffered_o          =   pipeline_ctrl_ex_rs1_src_mem2wb_i & pipeline_ctrl_ex_stall_o;
    assign pipeline_ctrl_ex_rs2_buffered_o          =   pipeline_ctrl_ex_rs2_src_mem2wb_i & pipeline_ctrl_ex_stall_o;


    always @( posedge clk ) begin
        if( rst ) begin
            intp_en_r <= 1'b0;
        end
        else if( pipeline_ctrl_inst_valid_o ) begin
            intp_en_r <= pipeline_ctrl_mem_csr_trap_i & ~pipeline_ctrl_ex2mem_inst_trap_i & ~pipeline_ctrl_ex2mem_inst_nop_i;
        end
        else begin
            intp_en_r <= intp_en_r;
        end
    end
    
    always @( posedge clk ) begin
        if( rst ) begin
            ex_rs1_src_buffered_r <= 1'b0;
        end
        else if( pipeline_ctrl_inst_valid_o ) begin
            if( pipeline_ctrl_ex_rs1_buffered_o ) begin
                ex_rs1_src_buffered_r <= 1'b1;
            end
            else if( ex_rs1_src_buffered_r | pipeline_ctrl_intp_en_o  ) begin
                ex_rs1_src_buffered_r <= 1'b0;
            end
            else begin
                ex_rs1_src_buffered_r <= ex_rs1_src_buffered_r;
            end
        end
        else begin
            ex_rs1_src_buffered_r <= ex_rs1_src_buffered_r;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            ex_rs2_src_buffered_r <= 1'b0;
        end
        else if( pipeline_ctrl_inst_valid_o ) begin
            if( pipeline_ctrl_ex_rs2_buffered_o ) begin
                ex_rs2_src_buffered_r <= 1'b1;
            end
            else if( ex_rs2_src_buffered_r | pipeline_ctrl_intp_en_o ) begin
                ex_rs2_src_buffered_r <= 1'b0;
            end
            else begin
                ex_rs2_src_buffered_r <= ex_rs2_src_buffered_r;
            end
        end
        else begin
            ex_rs2_src_buffered_r <= ex_rs2_src_buffered_r;
        end
    end
endmodule