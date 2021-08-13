// /***************************************************************************************
// * Copyright (c) 2020-2021 Institute of Computing Technology, Chinese Academy of Sciences
// * Copyright (c) 2020-2021 Peng Cheng Laboratory
// *
// * XiangShan is licensed under Mulan PSL v2.
// * You can use this software according to the terms and conditions of the Mulan PSL v2.
// * You may obtain a copy of Mulan PSL v2 at:
// *          http://license.coscl.org.cn/MulanPSL2
// *
// * THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
// * EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
// * MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// *
// * See the Mulan PSL v2 for more details.
// ***************************************************************************************/

// import "DPI-C" function void ram_write_helper
// (
//   input  longint    wIdx,
//   input  longint    wdata,
//   input  longint    wmask,
//   input  bit        wen
// );

// import "DPI-C" function longint ram_read_helper
// (
//   input  bit        en,
//   input  longint    rIdx
// );

// module RAMHelper(
//   input         clk,
//   input         en,
//   input  [63:0] rIdx,
//   output [63:0] rdata,
//   input  [63:0] wIdx,
//   input  [63:0] wdata,
//   input  [63:0] wmask,
//   input         wen
// );

//   assign rdata = ram_read_helper(en, rIdx);

//   always @(posedge clk) begin
//     ram_write_helper(wIdx, wdata, wmask, wen && en);
//   end

// endmodule

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


module ram_mem(
    input                       clk,
    
    input   [63:0]              inst_addr,
    input                       inst_en,
    output  [63:0]              inst,

    // DATA PORT
    input                       mem_write,
    input                       mem_read,
    input   [63:0]              write_mask,
    input   [63:0]              data_addr,
    input   [63:0]              write_data,
    output  [63:0]              read_data
);

    // INST PORT

    wire [63:0] inst_pre= ram_read_helper(inst_en,{3'b000,(inst_addr-64'h0000_0000_8000_0000)>>3});

    assign inst = inst_addr[2] ? inst_pre[63:32] : inst_pre[31:0];

    // DATA PORT 
    assign read_data = ram_read_helper(mem_read, {3'b000,(data_addr-64'h0000_0000_8000_0000)>>3});

    always @(posedge clk) begin
        ram_write_helper((data_addr-64'h0000_0000_8000_0000)>>3, write_data, write_mask, mem_write);
    end
    
endmodule