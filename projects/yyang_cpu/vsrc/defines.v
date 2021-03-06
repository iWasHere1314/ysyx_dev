`timescale 1ns / 1ps


/* if marco */
`define INST_ADDR_BUS           63:0
`define INST_BUS                31:0   
`define INST_ADDR_SIZE          64
`define INST_SIZE               32
`define PC_START                64'h00000000_80000000  
/* regfile marco */
`define REG_INDEX_BUS           4:0  
`define REG_INDEX_SIZE          5
`define REG_NUM                 (1<<`REG_INDEX_SIZE)
`define REG_BUS                 63:0
`define REG_BUS_SIZE            64
`define REG_ZERO                0

/* id marco */

//opcode and funct
`define OPCODE_LOC_BUS          6:0
`define EFF_OPCODE_LOC_BUS      6:2
`define EFF_OPCODE_BUS          4:0
`define FUNCT3_LOC_BUS          14:12
`define FUNCT7_LOC_BUS          31:25
`define OPCODE_BUS              6:0
`define FUNCT3_BUS              2:0
`define FUNCT7_BUS              6:0

`define EFF_OPCODE_LUI          5'b01101
`define EFF_OPCODE_AUIPC        5'b00101
`define EFF_OPCODE_JAL          5'b11011
`define EFF_OPCODE_JALR         5'b11001
`define EFF_OPCODE_BRANCH       5'b11000
`define EFF_OPCODE_LOAD         5'b00000
`define EFF_OPCODE_STORE        5'b01000
`define EFF_OPCODE_ALI          5'b00100
`define EFF_OPCODE_ALIW         5'b00110
`define EFF_OPCODE_AL           5'b01100
`define EFF_OPCODE_ALW          5'b01110

//register
`define RD_LOC_BUS              11:7
`define RS1_LOC_BUS             19:15
`define RS2_LOC_BUS             24:20

//immediate
`define GEN_TYPE_BUS            2:0
`define IMM_PRE_BUS             31:0
`define INST_31                 31:31
`define INST_31_12              31:12
`define INST_31_20              31:20
`define INST_31_25              31:25
`define INST_30_21              30:21
`define INST_30_25              30:25
`define INST_20                 20:20
`define INST_19_12              19:12
`define INST_11_7               11:7
`define INST_11_8               11:8
`define INST_7                  7:7

         
//alu control
`define ALU_OP_BUS              2:0
`define ALU_OP_SIZE             3

//compare
`define COMP_TYPE_BUS           2:0
`define COMP_TYPE_SIZE          3

//shift
`define SHIFT_TYPE_BUS          2:0
`define SHIFT_TYPE_SIZE         3
`define IMM_SHIFT_BUS           5:0
`define IMM_SHIFT_SIZE          6
`define INST_25_20              25:20
  
//store
`define STORE_TYPE_BUS          2:0
`define STORE_TYPE_SIZE         3

//load
`define LOAD_TYPE_BUS           2:0
`define LOAD_TYPE_SIZE          3

/* ex marco */
`define DATA_EXTEND_BUS         64:0
`define DATA_EXTEND_SIZE        65
`define DATA_BUS                63:0
`define DATA_BUS_SIZE           64
`define ALU_SRC_IMM             1
`define ALU_SRC_RS2             0

/* memory acess marco */
`define DATA_ADDR_BUS           63:0
`define ADDR_LOW_BUS            2:0
/*  */
`define ZERO_DWORD              64'h00000000_00000000   
     
`define INST_ADD                8'h11
