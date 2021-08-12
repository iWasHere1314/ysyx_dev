`include "defines.v"
module ex_top (
    /* control signals */
    // alu
    input                       alu_src_pc,
    input                       alu_src_imm,
    input   [`ALU_OP_BUS]       alu_op,
    // word instruction
    input                       inst_word,
    // branch or sltxx
    input                       inst_branch,
    input                       inst_sltxx,
    input   [`COMP_TYPE_BUS]    comp_type,
    // shift          
    input                       inst_shift,
    input                       shift_num_src,
    input   [`SHIFT_TYPE_BUS]   shift_type,

    /* data */
    input   [`INST_ADDR_BUS]    pc,
    input   [`DATA_BUS]         rs1_data,
    input   [`DATA_BUS]         rs2_data,
    input   [`DATA_BUS]         imm_data,
    input   [`IMM_SHIFT_BUS]    imm_shift,

    /* output */
    output  [`DATA_BUS]         alu_raw_res,
    output  [`DATA_BUS]         ex_odata,
    output                      branchjudge_res
);
    wire    [`DATA_BUS]         rs1_data_wordgen;
    wire    [`DATA_BUS]         rs2_data_wordgen;
    wire    [`DATA_BUS]         rs1_data_muxout;
    wire    [`DATA_BUS]         rs2_data_muxout;

    wire    [`DATA_EXTEND_BUS]  alu_res_data;
    wire    [`DATA_BUS]         branchjudge_res_data;
    wire    [`DATA_BUS]         shifter_res;
    wire    [`DATA_BUS]         alu_branchjudge_res_data;
    wire    [`DATA_BUS]         ex_odata_pre;
    wire    [`DATA_BUS]         ex_odata_wordgen;

    assign rs1_data_muxout          =   inst_word? rs1_data_wordgen: rs1_data;
    assign rs2_data_muxout          =   inst_word? rs2_data_wordgen: rs2_data;

    assign alu_branchjudge_res_data =   inst_sltxx? branchjudge_res_data: alu_res_data[`DATA_BUS];
    assign ex_odata_pre             =   inst_shift? shifter_res: alu_branchjudge_res_data;
    assign ex_odata                 =   inst_word? ex_odata_wordgen: ex_odata_pre;
    assign alu_raw_res              =   alu_res_data[`DATA_BUS];
    assign branchjudge_res          =   branchjudge_res_data[0];

    ex_alu my_ex_alu(
        /* control signals */
        
        // compare
        .comp_type( comp_type ), 
        
        // alu
        .alu_src_pc( alu_src_pc ),
        .alu_src_imm( alu_src_imm ),
        .alu_op( alu_op ),
        
        /* data */
        .pc( pc ),
        .rs1_data( rs1_data_muxout ),
        .rs2_data( rs2_data_muxout ),
        .imm_data( imm_data ),
    
        /* output */
        .alu_res_data( alu_res_data )
    );
    
    ex_branchjudge my_ex_branchjudge(
        /* control signals */
        .comp_type( comp_type ), 

        /* data */
        .alu_res_data( alu_res_data ),

        /* output */
        .branchjudge_res_data( branchjudge_res_data )
    );

    ex_shifter my_ex_shifter(
        /* control signals */
        // shift          
        .inst_shift( inst_shift ),
        .shift_type( shift_type ),
        .shift_num_src( shift_num_src ),

        /* data */
        .rs1_data( rs1_data_muxout ),
        .rs2_data( rs2_data ),
        .imm_shift( imm_shift ),

        /* output */
        .shifter_res( shifter_res )
    );
    
    ex_wordgen rs1_wordgen(
        /* control signals */
        .inst_word( inst_word ), 
    
        /* data */
        .wordgen_idata( rs1_data ),
    
        /* output */
        .wordgen_res_data( rs1_data_wordgen )
    );

    ex_wordgen rs2_wordgen(
        /* control signals */
        .inst_word( inst_word ), 
    
        /* data */
        .wordgen_idata( rs2_data ),
    
        /* output */
        .wordgen_res_data( rs2_data_wordgen )
    );

    ex_wordgen odata_wordgen(
        /* control signals */
        .inst_word( inst_word ), 
    
        /* data */
        .wordgen_idata( ex_odata_pre ),
    
        /* output */
        .wordgen_res_data( ex_odata_wordgen )
    );
    
endmodule
