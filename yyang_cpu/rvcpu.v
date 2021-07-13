
/* verilator lint_off UNUSED */
//--xuezhen--

`include "defines.v"

module rvcpu(
  input wire            clk,
  input wire            rst,
  input wire  [31 : 0]  inst,
  
  output wire [63 : 0]  inst_addr, 
  output wire           inst_ena
);

    wire  [`REG_INDEX]    rs1_index;
    wire  [`REG_INDEX]    rs2_index;
    wire                  rs1_ena;
    wire                  rs2_ena;
    wire  [`REG_INDEX]    rd_index;
    wire                  rd_ena;
    wire  [`DATA_BUS]     imm_data;
    wire                  alu_src;
    wire  [`DATA_BUS]     rd_data;
    wire  [`REG_BUS]      rs1_data;
    wire  [`REG_BUS]      rs2_data; 

    if_top my_if_top(
        .clk( clk ),
        .rst( rst ),
        .inst_addr( inst_addr ),
        .inst_ena( inst_ena )
    );

    id_top my_id_top(
        .inst( inst ),
        .rs1_index( rs1_index ),
        .rs2_index( rs2_index ),
        .rs1_ena( rs1_ena ),
        .rs2_ena( rs2_ena ),
        .rd_index( rd_index ),
        .rd_ena( rd_ena ),
        .imm_data( imm_data ),
        .alu_src( alu_src )
    );

    ex_top my_ex_top(
        .alu_src( alu_src),
        .oprand1( rs1_data ),
        .oprand2( rs2_data ),
        .imm_data( imm_data ),
        .rd_data( rd_data )
    );

    regfile my_regfile(
        .clk(clk),
        .rst(rst),
        .rd_ena(rd_ena),
        .rs1_index(rs1_index),
        .rs2_index(rs2_index),
        .rs1_ena(rs1_ena),
        .rs2_ena(rs2_ena),
        .rd_index(rd_index),
        .rd_data(rd_data),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data) 
    );
endmodule