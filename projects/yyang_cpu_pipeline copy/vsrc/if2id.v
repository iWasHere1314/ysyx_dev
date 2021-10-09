`include "defines.v"
module if2id(
    input                       clk,
    input                       rst,

    /* if2id control signals */
    input                       if2id_inst_valid_i,
    input                       if2id_if_flush_i,
    input                       if2id_id_stall_i,
    /* modules controls signals */    
    output                      if2id_inst_nop_o,

    /* data signals */
    input   [`INST_ADDR_BUS]    if2id_inst_addr_i,
    input   [`INST_BUS]         if2id_inst_i,
    
    output  [`INST_ADDR_BUS]    if2id_inst_addr_o,
    output  [`INST_BUS]         if2id_inst_o
);
    /* control reg */
    reg                         inst_nop_r;

    /* data reg */
    reg     [`INST_ADDR_BUS]    inst_addr_r;
    reg     [`INST_BUS]         inst_r;

    wire                        flush_en;
    wire                        stall_en;
    wire                        flow_en;
    
    assign flush_en             =   if2id_if_flush_i & if2id_inst_valid_i;
    assign stall_en             =   if2id_id_stall_i & if2id_inst_valid_i;
    assign flow_en              =   if2id_inst_valid_i;
    
    assign if2id_inst_nop_o     =   inst_nop_r;
    assign if2id_inst_addr_o    =   inst_addr_r;
    assign if2id_inst_o         =   inst_r;
    
    always @( posedge clk ) begin
        if( rst | flush_en ) begin
            inst_nop_r <= 1'b1;
        end
        else if( stall_en )begin
            inst_nop_r <= inst_nop_r;
        end
        else if( flow_en )begin
            inst_nop_r <= 1'b0;
        end
        else begin
            inst_nop_r <= inst_nop_r;
        end
    end
    
    always @( posedge clk ) begin
        if( rst | flush_en ) begin
            inst_addr_r <= `PC_START;    
        end
        else if( stall_en ) begin
            inst_addr_r <= inst_addr_r;
        end
        else if( flow_en ) begin
            inst_addr_r <= if2id_inst_addr_i;
        end
        else begin
            inst_addr_r <= inst_addr_r;
        end
    end

    always @( posedge clk ) begin
        if( rst | if2id_if_flush_i ) begin
            inst_r  <= `INST_NOP;
        end
        else if( stall_en ) begin
            inst_r <= inst_r;
        end
        else if( flow_en ) begin
            inst_r <= if2id_inst_i;
        end
        else begin
            inst_r <= inst_r;
        end
    end
    
endmodule