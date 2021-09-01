`include "defines.v"
module if_top (
    input                       clk,
    input                       rst,
    input                       branchjudge_ok,
    input                       inst_jump,
    input   [`INST_ADDR_BUS]    jump_addr,
    input   [`DATA_BUS]         imm_offset,
    
    input                       if_ready,
    input   [`INST_BUS]         if_data_read,
    input   [1:0]               if_resp,

    output  [`INST_ADDR_BUS]    inst_addr,
    output                      if_valid,
    output  [`INST_ADDR_BUS]    if_addr,
    output  [1:0]               if_size,
    output                      inst_valid,
    output  [`INST_BUS]         inst,
    output                      if_req
);
    reg     [`INST_BUS]         inst_r;
    wire    [`INST_ADDR_BUS]    nxt_inst_addr;
    wire                        handshake_done;

    assign nxt_inst_addr        =   inst_jump? jump_addr: ( inst_addr + ( branchjudge_ok? imm_offset: `INST_ADDR_SIZE'h4 )  );    
    assign if_addr              =   nxt_inst_addr;
    assign if_valid             =   1'b1;
    assign if_size              =   `SIZE_W;
    assign inst_valid           =   handshake_done & ( inst_addr != `PC_START - 64'h4 );
    assign handshake_done       =   if_valid & if_ready;
    assign if_req               =   `REQ_READ;
    assign inst                 =   inst_r;
    always @( posedge clk ) begin
        if( rst ) begin
            inst_r <= `INST_NOP;
        end
        else if( handshake_done )begin
            inst_r <= if_data_read[`INST_BUS];
        end
        else begin
            inst_r <= inst_r;
        end
    end

    if_pc my_if_pc(
        .clk(clk),
        .rst(rst),
        .nxt_inst_addr( nxt_inst_addr ),
        .inst_valid( inst_valid ),
        .cur_inst_addr ( inst_addr )
    );

endmodule
