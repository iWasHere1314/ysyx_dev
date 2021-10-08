`include "defines.v"
module mem_clint_dstb (
    /* input side */
    input                       mem_clint_dstb_valid_i,
    output                      mem_clint_dstb_ready_o,
    output  [`DATA_BUS]         mem_clint_dstb_data_read_o,
    input   [`DATA_BUS]         mem_clint_dstb_data_write_i,
    input   [`DATA_ADDR_BUS]    mem_clint_dstb_addr_i,
    input   [1:0]               mem_clint_dstb_size_i,
    output  [1:0]               mem_clint_dstb_resp_o,
    input                       mem_clint_dstb_req_i,

    /* mem side */
    output                      mem_clint_dstb_mem_valid_o,
    input                       mem_clint_dstb_mem_ready_i,
    input   [`DATA_BUS]         mem_clint_dstb_mem_data_read_i,
    output  [`DATA_BUS]         mem_clint_dstb_mem_data_write_o,
    output  [`DATA_ADDR_BUS]    mem_clint_dstb_mem_addr_o,
    output  [1:0]               mem_clint_dstb_mem_size_o,
    input   [1:0]               mem_clint_dstb_mem_resp_i,
    output                      mem_clint_dstb_mem_req_o,

    /* clint side */
    output                      mem_clint_dstb_clint_valid_o,
    input                       mem_clint_dstb_clint_ready_i,
    input   [`DATA_BUS]         mem_clint_dstb_clint_data_read_i,
    output  [`DATA_BUS]         mem_clint_dstb_clint_data_write_o,
    output  [`DATA_ADDR_BUS]    mem_clint_dstb_clint_addr_o,
    output  [1:0]               mem_clint_dstb_clint_size_o,
    input   [1:0]               mem_clint_dstb_clint_resp_i,
    output                      mem_clint_dstb_clint_req_o
    
    `ifdef DEFINE_DIFFTEST
    ,
    output                      mem_clint_dstb_skip_o
    `endif
);
    wire                        to_clint;
    wire                        to_other;

    assign to_clint                             =   ( mem_clint_dstb_addr_i == `MTIME_ADDR ) 
                                                    | ( mem_clint_dstb_addr_i == `MTIMECMP_ADDR );
    assign to_other                             =   ~to_clint;
    
    `ifdef DEFINE_DIFFTEST
    assign mem_clint_dstb_skip_o                =   to_clint;
    `endif

    assign mem_clint_dstb_ready_o               =   to_clint? mem_clint_dstb_clint_ready_i: mem_clint_dstb_mem_ready_i;
    assign mem_clint_dstb_data_read_o           =   to_clint? mem_clint_dstb_clint_data_read_i: mem_clint_dstb_mem_data_read_i;
    assign mem_clint_dstb_resp_o                =   to_clint? mem_clint_dstb_clint_resp_i: mem_clint_dstb_mem_resp_i;
    
    assign mem_clint_dstb_mem_valid_o           =   to_other & mem_clint_dstb_valid_i;
    assign mem_clint_dstb_mem_data_write_o      =   { `DATA_BUS_SIZE { to_other } } & mem_clint_dstb_data_write_i;
    assign mem_clint_dstb_mem_addr_o            =   { `DATA_BUS_SIZE { to_other } } & mem_clint_dstb_addr_i;
    assign mem_clint_dstb_mem_size_o            =   { 2 { to_other } } & mem_clint_dstb_size_i;
    assign mem_clint_dstb_mem_req_o             =   to_other & mem_clint_dstb_req_i;

    assign mem_clint_dstb_clint_valid_o         =   to_clint & mem_clint_dstb_valid_i;
    assign mem_clint_dstb_clint_data_write_o    =   { `DATA_BUS_SIZE { to_clint } } & mem_clint_dstb_data_write_i;
    assign mem_clint_dstb_clint_addr_o          =   { `DATA_BUS_SIZE { to_clint } } & mem_clint_dstb_addr_i;
    assign mem_clint_dstb_clint_size_o          =   { 2 { to_clint } } & mem_clint_dstb_size_i;
    assign mem_clint_dstb_clint_req_o           =   to_clint & mem_clint_dstb_req_i;

endmodule