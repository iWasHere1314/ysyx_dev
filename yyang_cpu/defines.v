
`timescale 1ns / 1ps


/* if marco */
`define INST_ADDR               63:0
`define INST_BUS                31:0   
`define INST_ADDR_SIZE          64
`define INST_SIZE               32

/* regfile marco */
`define REG_INDEX               4:0  
`define REG_INDEX_SIZE          5
`define REG_NUM                 (1<<`REG_INDEX_SIZE)
`define REG_BUS                 63:0
`define REG_BUS_SIZE            64
`define REG_ZERO                0

/* id marco */
`define OPCODE_BUS              6:0
`define RD_BUS                  11:7
`define FUNCT3_BUS              14:12
`define RS1_BUS                 19:15
`define RS2_BUS                 24:20
`define FUNCT7_BUS              31:25
`define S_IMM_H_BUS             11:7
`define S_IMM_L_BUS             11:7 
`define I_IMM_BUS               31:20
`define I_IMM                   11:0
`define I_IMM_SIZE              12
`define INST_ARH_LOG_I          7'b0010011
`define INST_ARH_LOG_I_ADDI     3'b000

//目前时间有限，暂时不考虑。。。其他的          

/* ex marco */
`define DATA_BUS                63:0
`define DATA_BUS_SIZE           64
`define ALU_SRC_IMM             1
`define ALU_SRC_RS2             0
/*  */
`define ZERO_WORD               64'h00000000_00000000   
     
`define INST_ADD                8'h11
