`include "defines.v"
module id_forward (
    /* control signals */
    input                       id_forward_inst_lui_i,
    input                       id_forward_id_rs1_en_i,
    input                       id_forward_id_rs2_en_i,
    input                       id_forward_id2ex_rd_en_i,
    input                       id_forward_ex2mem_rd_en_i,
    input                       id_forward_mem2wb_rd_en_i,
    
    input   [`REG_INDEX_BUS]    id_forward_id_rs1_index_i,
    input   [`REG_INDEX_BUS]    id_forward_id_rs2_index_i,
    input   [`REG_INDEX_BUS]    id_forward_id2ex_rd_index_i,
    input   [`REG_INDEX_BUS]    id_forward_ex2mem_rd_index_i,
    input   [`REG_INDEX_BUS]    id_forward_mem2wb_rd_index_i,

    output                      id_forward_id_rs1_src_reg_o,
    output                      id_forward_id_rs1_src_id2ex_o,
    output                      id_forward_id_rs1_src_ex2mem_o,
    output                      id_forward_id_rs1_src_mem2wb_o,
    output                      id_forward_id_rs2_src_reg_o,
    output                      id_forward_id_rs2_src_id2ex_o,
    output                      id_forward_id_rs2_src_ex2mem_o,
    output                      id_forward_id_rs2_src_mem2wb_o
);
    /* rename */
    wire                        inst_lui;
    wire                        id_rs1_en;
    wire                        id_rs2_en;
    wire                        id2ex_rd_en;
    wire                        ex2mem_rd_en;
    wire                        mem2wb_rd_en;
    wire                        id_rs1_src_reg;
    wire                        id_rs1_src_id2ex;
    wire                        id_rs1_src_ex2mem;
    wire                        id_rs1_src_mem2wb;
    wire                        id_rs2_src_reg;
    wire                        id_rs2_src_id2ex;
    wire                        id_rs2_src_ex2mem;
    wire                        id_rs2_src_mem2wb; 

    wire    [`REG_INDEX_BUS]    id_rs1_index;
    wire    [`REG_INDEX_BUS]    id_rs2_index;
    wire    [`REG_INDEX_BUS]    id2ex_rd_index;
    wire    [`REG_INDEX_BUS]    ex2mem_rd_index;
    wire    [`REG_INDEX_BUS]    mem2wb_rd_index;
    /* rename */

    wire                        id_rs1_src_id2ex_n;
    wire                        id_rs1_src_ex2mem_n;
    wire                        id_rs1_src_mem2wb_n;
    wire                        id_rs2_src_id2ex_n;
    wire                        id_rs2_src_ex2mem_n;
    wire                        id_rs2_src_mem2wb_n; 

    /* rename */
    assign inst_lui                         =   id_forward_inst_lui_i;
    assign id_rs1_en                        =   id_forward_id_rs1_en_i;
    assign id_rs2_en                        =   id_forward_id_rs2_en_i;
    assign id2ex_rd_en                      =   id_forward_id2ex_rd_en_i;
    assign ex2mem_rd_en                     =   id_forward_ex2mem_rd_en_i;
    assign mem2wb_rd_en                     =   id_forward_mem2wb_rd_en_i;
    assign id_forward_id_rs1_src_reg_o      =   id_rs1_src_reg;
    assign id_forward_id_rs1_src_id2ex_o    =   id_rs1_src_id2ex;
    assign id_forward_id_rs1_src_ex2mem_o   =   id_rs1_src_ex2mem;
    assign id_forward_id_rs1_src_mem2wb_o   =   id_rs1_src_mem2wb;
    assign id_forward_id_rs2_src_reg_o      =   id_rs2_src_reg;
    assign id_forward_id_rs2_src_id2ex_o    =   id_rs2_src_id2ex;
    assign id_forward_id_rs2_src_ex2mem_o   =   id_rs2_src_ex2mem;
    assign id_forward_id_rs2_src_mem2wb_o   =   id_rs2_src_mem2wb;

    assign id_rs1_index                     =   id_forward_id_rs1_index_i;
    assign id_rs2_index                     =   id_forward_id_rs2_index_i;
    assign id2ex_rd_index                   =   id_forward_id2ex_rd_index_i;
    assign ex2mem_rd_index                  =   id_forward_ex2mem_rd_index_i;
    assign mem2wb_rd_index                  =   id_forward_mem2wb_rd_index_i;
    /* rename */
    assign id_rs1_src_id2ex_n               =   ~id_rs1_src_id2ex;
    assign id_rs1_src_ex2mem_n              =   ~id_rs1_src_ex2mem;
    assign id_rs1_src_mem2wb_n              =   ~id_rs1_src_mem2wb;
    assign id_rs2_src_id2ex_n               =   ~id_rs2_src_id2ex;
    assign id_rs2_src_ex2mem_n              =   ~id_rs2_src_ex2mem;
    assign id_rs2_src_mem2wb_n              =   ~id_rs2_src_mem2wb;
    
    assign id_rs1_src_reg                   =   id_rs1_src_id2ex_n & id_rs1_src_ex2mem_n & id_rs1_src_mem2wb_n;
    assign id_rs1_src_id2ex                 =   inst_lui & ( id2ex_rd_index != `REG_INDEX_SIZE'b0 )
                                                & ( id_rs1_index == id2ex_rd_index ) & id_rs1_en & id2ex_rd_en;
    assign id_rs1_src_ex2mem                =   id_rs1_src_id2ex_n & ( ex2mem_rd_index != `REG_INDEX_SIZE'b0 )
                                                & ( id_rs1_index == ex2mem_rd_index )& id_rs1_en & ex2mem_rd_en;
    assign id_rs1_src_mem2wb                =   id_rs1_src_id2ex_n & id_rs1_src_ex2mem_n & ( mem2wb_rd_index != `REG_INDEX_SIZE'b0 )
                                                & ( id_rs1_index == mem2wb_rd_index )& id_rs1_en & mem2wb_rd_en;
    
    assign id_rs2_src_reg                   =   id_rs2_src_id2ex_n & id_rs2_src_ex2mem_n & id_rs2_src_mem2wb_n;
    assign id_rs2_src_id2ex                 =   inst_lui & ( id2ex_rd_index != `REG_INDEX_SIZE'b0 )
                                                & ( id_rs2_index == id2ex_rd_index ) & id_rs2_en & id2ex_rd_en;
    assign id_rs2_src_ex2mem                =   id_rs2_src_id2ex_n & ( ex2mem_rd_index != `REG_INDEX_SIZE'b0 )
                                                & ( id_rs2_index == ex2mem_rd_index )& id_rs2_en & ex2mem_rd_en;
    assign id_rs2_src_mem2wb                =   id_rs2_src_id2ex_n & id_rs2_src_ex2mem_n & ( mem2wb_rd_index != `REG_INDEX_SIZE'b0 )
                                                & ( id_rs2_index == mem2wb_rd_index )& id_rs2_en & mem2wb_rd_en;
endmodule