`include "defines.v"
module if_top (
    input                       clk,
    input                       rst,

    /* control signals */
    input                       if_top_jumpbranch_en_i,
    input                       if_top_trap_en_i,
    input                       if_top_inst_valid_i,
    input                       if_top_dont_fetch_i,

    output                      if_top_fetched_ok_o,

    /* data signals */
    input   [`INST_ADDR_BUS]    if_top_jumpbranch_addr_i,
    input   [`INST_ADDR_BUS]    if_top_csr_nxt_pc_i,
    
    
    /* bus interface */
    input                       if_top_if_ready_i,
    input   [`DATA_BUS]         if_top_if_data_read_i,
    input   [1:0]               if_top_if_resp_i,

    output  [`INST_ADDR_BUS]    if_top_inst_addr_o,
    output                      if_top_if_valid_o,
    output  [`INST_ADDR_BUS]    if_top_if_addr_o,
    output  [1:0]               if_top_if_size_o,
    output  [`INST_BUS]         if_top_inst_o,
    output                      if_top_if_req_o
);
    wire    [`INST_ADDR_BUS]    nxt_inst_addr;
    wire                        handshake_done;

    assign nxt_inst_addr            =   if_top_trap_en_i? if_top_csr_nxt_pc_i:
                                         ( if_top_jumpbranch_en_i ? if_top_jumpbranch_addr_i : if_top_inst_addr_o + 64'd4 );    
    assign if_top_fetched_ok_o      =   handshake_done | if_top_dont_fetch_i;

    assign if_top_if_addr_o         =   if_top_inst_addr_o;
    assign if_top_if_valid_o        =   ~if_top_dont_fetch_i;
    assign if_top_if_size_o         =   `SIZE_W;
    assign handshake_done           =   if_top_if_valid_o & if_top_if_ready_i;
    assign if_top_if_req_o          =   `REQ_READ;
    assign if_top_inst_o            =   if_top_if_data_read_i[`INST_BUS];

    if_pc my_if_pc(
        .clk( clk ),
        .rst( rst ),

        /* control signals */
        .if_pc_inst_valid_i( if_top_inst_valid_i ),
        /* data_signals */
        .if_pc_nxt_inst_addr_i( nxt_inst_addr ),
        .if_pc_cur_inst_addr_o( if_top_inst_addr_o )
    );
endmodule
