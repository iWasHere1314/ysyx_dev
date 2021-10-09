`include "defines.v"
module  ex_forward(
    input                       ex_forward_mem_write_i,
    input                       ex_forward_mem_read_i,
    input                       ex_forward_inst_arth_lgc_i,

    input                       ex_forward_id2ex_rs1_en_i,
    input                       ex_forward_id2ex_rs2_en_i,
    input                       ex_forward_ex2mem_rd_en_i,
    input                       ex_forward_mem2wb_rd_en_i,
    input   [`REG_INDEX_BUS]    ex_forward_id2ex_rs1_index_i,
    input   [`REG_INDEX_BUS]    ex_forward_id2ex_rs2_index_i,
    input   [`REG_INDEX_BUS]    ex_forward_ex2mem_rd_index_i,
    input   [`REG_INDEX_BUS]    ex_forward_mem2wb_rd_index_i,

    output                      ex_forward_ex_rs1_src_id2ex_o,
    output                      ex_forward_ex_rs1_src_ex2mem_o,
    output                      ex_forward_ex_rs1_src_mem2wb_o,
    output                      ex_forward_ex_rs2_src_id2ex_o,
    output                      ex_forward_ex_rs2_src_ex2mem_o,
    output                      ex_forward_ex_rs2_src_mem2wb_o
);
    wire                        ex_forward_ex_rs1_src_ex2mem_n;
    wire                        ex_forward_ex_rs1_src_mem2wb_n;
    wire                        ex_forward_ex_rs2_src_ex2mem_n;
    wire                        ex_forward_ex_rs2_src_mem2wb_n;
    wire                        rs1_fwd;

    assign ex_forward_ex_rs1_src_ex2mem_n   = ~ex_forward_ex_rs1_src_ex2mem_o;
    assign ex_forward_ex_rs1_src_mem2wb_n   = ~ex_forward_ex_rs1_src_mem2wb_o;

    assign ex_forward_ex_rs2_src_ex2mem_n   = ~ex_forward_ex_rs2_src_ex2mem_o;
    assign ex_forward_ex_rs2_src_mem2wb_n   = ~ex_forward_ex_rs2_src_mem2wb_o;
    
    assign rs1_fwd                          = ex_forward_mem_write_i | ex_forward_mem_read_i | ex_forward_inst_arth_lgc_i;

    assign ex_forward_ex_rs1_src_id2ex_o    =   ex_forward_ex_rs1_src_ex2mem_n & ex_forward_ex_rs1_src_mem2wb_n;
    assign ex_forward_ex_rs1_src_ex2mem_o   =   ( ex_forward_ex2mem_rd_index_i != `REG_INDEX_SIZE'b0 ) 
                                                & ex_forward_ex2mem_rd_index_i == ex_forward_id2ex_rs1_index_i
                                                & ex_forward_id2ex_rs1_en_i & ex_forward_ex2mem_rd_en_i
                                                & rs1_fwd;
    assign ex_forward_ex_rs1_src_mem2wb_o   =   ( ex_forward_mem2wb_rd_index_i != `REG_INDEX_SIZE'b0 )  
                                                & ex_forward_mem2wb_rd_index_i == ex_forward_id2ex_rs1_index_i
                                                & ex_forward_ex_rs1_src_ex2mem_n & ex_forward_id2ex_rs1_en_i 
                                                & ex_forward_mem2wb_rd_en_i
                                                & rs1_fwd;

    assign ex_forward_ex_rs2_src_id2ex_o    =   ex_forward_ex_rs2_src_ex2mem_n & ex_forward_ex_rs2_src_mem2wb_n;
    assign ex_forward_ex_rs2_src_ex2mem_o   =   ( ex_forward_ex2mem_rd_index_i != `REG_INDEX_SIZE'b0 ) 
                                                & ex_forward_ex2mem_rd_index_i == ex_forward_id2ex_rs2_index_i
                                                & ex_forward_id2ex_rs2_en_i & ex_forward_ex2mem_rd_en_i;
    assign ex_forward_ex_rs2_src_mem2wb_o   =   ( ex_forward_mem2wb_rd_index_i != `REG_INDEX_SIZE'b0 )  
                                                & ex_forward_mem2wb_rd_index_i == ex_forward_id2ex_rs2_index_i
                                                & ex_forward_ex_rs2_src_ex2mem_n & ex_forward_id2ex_rs2_en_i 
                                                & ex_forward_mem2wb_rd_en_i;
endmodule