`include "defines.v"
module if_mem_arbiter  # (
    parameter RW_DATA_WIDTH     = 64,
    parameter AXI_DATA_WIDTH    = 64
)
(
    /* if */
    output                          if_ready,
    output  [`DATA_BUS]             if_data_read,
    output  [1:0]                   if_resp,

    input                           if_valid,
    input   [`INST_ADDR_BUS]        if_addr,
    input   [1:0]                   if_size,
    input                           if_req,

    /* mem */   
    input                           mem_valid,
	output                          mem_ready,
    output  [`DATA_BUS]             mem_data_read,
    input   [`DATA_BUS]             mem_data_write,
    input   [`DATA_ADDR_BUS]        mem_addr,
    input   [1:0]                   mem_size,
    output  [1:0]                   mem_resp,
    input                           mem_req,

    /* axi_rw */    
    output                          rw_valid,
	input                           rw_ready,
    output                          rw_req,
    input   [RW_DATA_WIDTH-1:0]     data_read,
    output  [RW_DATA_WIDTH-1:0]     data_write,
    output  [AXI_DATA_WIDTH-1:0]    rw_addr,
    output  [1:0]                   rw_size,
    input   [1:0]                   rw_resp,
    output  [3:0]                   rw_id
);

    parameter STATE_IF = 1'b0, STATE_MEM = 1'b1;
    wire                        state_cur;
    wire                        state_cur_if;
    wire                        state_cur_mem;

    assign state_cur            =   mem_valid? STATE_MEM: STATE_IF;
    assign state_cur_if         =   state_cur == STATE_IF;
    assign state_cur_mem        =   state_cur == STATE_MEM;

    assign rw_valid             =   state_cur_if ? if_valid: mem_valid;
    assign if_ready             =   state_cur_if & rw_ready; 
    assign mem_ready            =   state_cur_mem & rw_ready;
    assign rw_req               =   state_cur_if ? if_req: mem_req;
    assign if_data_read         =   data_read;
    assign mem_data_read        =   data_read;  
    assign data_write           =   mem_data_write;
    assign rw_addr              =   state_cur_if ? if_addr: mem_addr;
    assign rw_size              =   state_cur_if ? if_size: mem_size;
    assign if_resp              =   rw_resp;
    assign mem_resp             =   rw_resp;
    assign rw_id                =   4'h0; 
    
endmodule