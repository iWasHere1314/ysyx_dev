`include "defines.v"
module mem_forward(
    input                       mem_forward_ex2mem_rs1_en_i,
    input                       mem_forward_ex2mem_rs2_en_i,
    input                       mem_forward_mem2wb_rd_en_i,
    input   [`REG_INDEX_BUS]    mem_forward_ex2mem_rs1_index_i,
    input   [`REG_INDEX_BUS]    mem_forward_ex2mem_rs2_index_i,
    input   [`REG_INDEX_BUS]    mem_forward_mem2wb_rd_index_i,
    
    output                      mem_forward_ex_rs1_src_ex2mem_o,
    output                      mem_forward_ex_rs1_src_mem2wb_o,
    output                      mem_forward_ex_rs2_src_ex2mem_o,
    output                      mem_forward_ex_rs2_src_mem2wb_o
);
    wire                        mem_forward_ex_rs1_src_mem2wb_n;
    wire                        mem_forward_ex_rs2_src_mem2wb_n;

    assign mem_forward_ex_rs1_src_mem2wb_n  =   ~mem_forward_ex_rs1_src_mem2wb_o;
    assign mem_forward_ex_rs2_src_mem2wb_n  =   ~mem_forward_ex_rs2_src_mem2wb_o;

    assign mem_forward_ex_rs1_src_ex2mem_o  =   mem_forward_ex_rs1_src_mem2wb_n;
    assign mem_forward_ex_rs2_src_ex2mem_o  =   mem_forward_ex_rs2_src_mem2wb_n;

    assign mem_forward_ex_rs1_src_mem2wb_o  =   ( mem_forward_mem2wb_rd_index_i != `REG_INDEX_SIZE'b0 )
                                                & ( mem_forward_mem2wb_rd_index_i == mem_forward_ex2mem_rs1_index_i )
                                                & mem_forward_mem2wb_rd_en_i & mem_forward_ex2mem_rs1_en_i;  

    assign mem_forward_ex_rs2_src_mem2wb_o  =   ( mem_forward_mem2wb_rd_index_i != `REG_INDEX_SIZE'b0 )
                                                & ( mem_forward_mem2wb_rd_index_i == mem_forward_ex2mem_rs2_index_i )
                                                & mem_forward_mem2wb_rd_en_i & mem_forward_ex2mem_rs2_en_i;  
                                                
endmodule