`include "defines.v"
module clint_dstb (
    input                       clint_dstb_valid,
    output                      clint_dstb_ready,
    output  [`DATA_BUS]         clint_dstb_data_read,
    input   [`DATA_BUS]         clint_dstb_data_write,
    input   [`DATA_ADDR_BUS]    clint_dstb_addr,
    input   [1:0]               clint_dstb_size,
    output  [1:0]               clint_dstb_resp,
    input                       clint_dstb_req,

    output                      clint_dstb_mem_valid,
    input                       clint_dstb_mem_ready,
    input   [`DATA_BUS]         clint_dstb_mem_data_read,
    output  [`DATA_BUS]         clint_dstb_mem_data_write,
    output  [`DATA_ADDR_BUS]    clint_dstb_mem_addr,
    output  [1:0]               clint_dstb_mem_size,
    input   [1:0]               clint_dstb_mem_resp,
    output                      clint_dstb_mem_req,

    output                      clint_valid,
    input                       clint_ready,
    input   [`DATA_BUS]         clint_data_read,
    output  [`DATA_BUS]         clint_data_write,
    output  [`DATA_ADDR_BUS]    clint_addr,
    output  [1:0]               clint_size,
    input   [1:0]               clint_resp,
    output                      clint_req
    `ifdef DEFINE_DIFFTEST
                                            ,
    output                      clint_skip
    `endif
);
    wire                        to_clint;
    wire                        to_other;

    assign to_clint                     =   ( clint_dstb_addr == `MTIME_ADDR ) | ( clint_dstb_addr == `MTIMECMP_ADDR );
    assign to_other                     =   ~to_clint;
    
    `ifdef DEFINE_DIFFTEST
    assign clint_skip                   =   to_clint;
    `endif

    assign clint_dstb_ready             =   to_clint? clint_ready: clint_dstb_mem_ready;
    assign clint_dstb_data_read         =   to_clint? clint_data_read: clint_dstb_mem_data_read;
    assign clint_dstb_resp              =   to_clint? clint_resp: clint_dstb_mem_resp;
    
    assign clint_dstb_mem_valid         =   to_other & clint_dstb_valid;
    assign clint_dstb_mem_data_write    =   { `DATA_BUS_SIZE { to_other } } & clint_dstb_data_write;
    assign clint_dstb_mem_addr          =   { `DATA_BUS_SIZE { to_other } } & clint_dstb_addr;
    assign clint_dstb_mem_size          =   { 2 { to_other } } & clint_dstb_size;
    assign clint_dstb_mem_req           =   to_other & clint_dstb_req;

    assign clint_valid                  =   to_clint & clint_dstb_valid;
    assign clint_data_write             =   { `DATA_BUS_SIZE { to_clint } } & clint_dstb_data_write;
    assign clint_addr                   =   { `DATA_BUS_SIZE { to_clint } } & clint_dstb_addr;
    assign clint_size                   =   { 2 { to_clint } } & clint_dstb_size;
    assign clint_req                    =   to_other & clint_dstb_req;

endmodule