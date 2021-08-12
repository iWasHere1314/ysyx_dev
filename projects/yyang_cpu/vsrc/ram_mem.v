import "DPI-C" function void ram_write_helper
(
  input  longint    wIdx,
  input  longint    wdata,
  input  longint    wmask,
  input  bit        wen
);

import "DPI-C" function longint ram_read_helper
(
  input  bit        en,
  input  longint    rIdx
);

`include "defines.v"

module ram_mem(
    input                       clk,
    
    input   [`INST_ADDR_BUS]    inst_addr,
    input                       inst_en,
    output  [`INST_BUS]         inst,

    // DATA PORT
    input                       mem_write,
    input                       mem_read,
    input   [`DATA_BUS]         write_mask,
    input   [`DATA_ADDR_BUS]    data_addr,
    input   [`DATA_BUS]         write_data,
    output  [`DATA_BUS]         read_data
);

    // INST PORT

    wire [`DATA_BUS] inst_pre= ram_read_helper(inst_en,{3'b000,(inst_addr-64'h0000_0000_8000_0000)>>3});

    assign inst = inst_addr[2] ? inst_pre[63:32] : inst_pre[31:0];

    // DATA PORT 
    assign read_data = ram_read_helper(mem_read, {3'b000,(data_addr-64'h0000_0000_8000_0000)>>3});

    always @(posedge clk) begin
        ram_write_helper((data_addr-64'h0000_0000_8000_0000)>>3, write_data, write_mask, mem_write);
    end
    
endmodule