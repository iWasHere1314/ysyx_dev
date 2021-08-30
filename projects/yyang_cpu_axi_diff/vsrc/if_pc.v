`include "defines.v"

module if_pc (
    input                       clk,
    input                       rst,
    input   [`INST_ADDR_BUS]    nxt_inst_addr,
    output  [`INST_ADDR_BUS]    cur_inst_addr 
);
    parameter PC_START_RESET = `PC_START - 4;
    reg [`INST_ADDR_BUS] cur_inst_addr_r;
    always @( posedge clk ) begin
        if( rst == 1'b1 ) begin
            cur_inst_addr_r <= PC_START_RESET;
        end
        else begin
            cur_inst_addr_r <= nxt_inst_addr;
        end
    end

    assign cur_inst_addr = cur_inst_addr_r;
    
endmodule
