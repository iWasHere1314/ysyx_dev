`include "defines.v"
/* verilator lint_off UNUSED */

module id_top (
    input   [`INST_BUS]         inst,
    
    /* register control */
    output  [`REG_INDEX_BUS]    rs1_index,
    output  [`REG_INDEX_BUS]    rs2_index,
    output                      rs1_en,
    output                      rs2_en,
    output  [`REG_INDEX_BUS]    rd_index,
    output                      rd_en,

    /* instruction type */
    output                      inst_sltxx,
    output                      inst_shift,
    output                      inst_lui,
    output                      inst_load,
    output                      inst_jump,
    output                      inst_word,
    output                      inst_branch,
    output                      inst_csr,

    /* immediate */
    output  [`DATA_BUS]         imm_data,

    /* memory control */
    output                      mem_write,
    output                      mem_read,

    /* alu control */
    output                      alu_src_pc,
    output                      alu_src_imm,
    output  [`ALU_OP_BUS]       alu_op,

    /* compare */
    output [`COMP_TYPE_BUS]     comp_type,

    /* shift */
    output [`SHIFT_TYPE_BUS]    shift_type,
    output                      shift_num_src,
    output [`IMM_SHIFT_BUS]     imm_shift,

    /* store */
    output [`STORE_TYPE_BUS]    store_type,

    /* load */
    output [`LOAD_TYPE_BUS]     load_type,

        /* csr */
    output [`CSR_INDEX_BUS]     csr_index,
    output [`CSR_CTRL_BUS]      csr_ctrl,
    output                      csr_src,                   
    output [`DATA_BUS]          imm_csr,

    /* instruction */
    output                      inst_en
    `ifdef DEFINE_PUTCH
    ,
    output                      inst_selfdefine
    `endif
);
    wire [`GEN_TYPE_BUS] gen_type;

    assign rs1_index    =   inst[`RS1_LOC_BUS];
    assign rs2_index    =   inst[`RS2_LOC_BUS];
    assign rd_index     =   inst[`RD_LOC_BUS];
    assign csr_index    =   inst[`CSR_LOC_BUS];

    id_immgen my_id_immgen(
        .inst( inst ),
        .gen_type( gen_type ),
        .imm_data( imm_data ),
        .imm_shift( imm_shift),
        .imm_csr( imm_csr )
    );

    id_control my_id_control(
        /* input */

        `ifdef DEFINE_PUTCH
        .inst( inst ),
        `endif 

        .opcode( inst[`OPCODE_LOC_BUS] ),
        .funct3( inst[`FUNCT3_LOC_BUS] ),
        .funct7( inst[`FUNCT7_LOC_BUS] ),
    
        /* register control */
        .rs1_en( rs1_en ),
        .rs2_en( rs2_en ),
        .rd_en( rd_en ),

        /* instruction type */
        .inst_sltxx( inst_sltxx ),
        .inst_shift( inst_shift ),
        .inst_lui( inst_lui ),
        .inst_load( inst_load ),
        .inst_jump( inst_jump ),
        .inst_word( inst_word ),
        .inst_branch( inst_branch ),
        .inst_csr( inst_csr ),
        
        /* memory control */
        .mem_write( mem_write ),
        .mem_read( mem_read ),

        /* immediate number */
        .gen_type( gen_type ),

        /* alu control */
        .alu_src_pc( alu_src_pc ),
        .alu_src_imm( alu_src_imm ),
        .alu_op( alu_op ),

        /* compare */
        .comp_type( comp_type ),

        /* shift */
        .shift_type( shift_type ),
        .shift_num_src( shift_num_src ),

        /* store */
        .store_type( store_type ),

        /* load */
        .load_type( load_type ),

        /* csr  */
        .csr_ctrl( csr_ctrl ),
        .csr_src( csr_src ),

        /* instruction */
        .inst_en( inst_en )

        `ifdef DEFINE_PUTCH
        ,
        .inst_selfdefine( inst_selfdefine )
        `endif

    );

endmodule
