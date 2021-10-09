`include "defines.v"
module ex_wordgen (
    /* control signals */
    input                       ex_wordgen_inst_word_i, 

    /* data */
    input   [`DATA_BUS]         ex_wordgen_wordgen_src_data_i,

    /* output */
    output  [`DATA_BUS]         ex_wordgen_res_data_o
);

    wire    [`DATA_BUS]         wordgen_res_data_pre;

    assign wordgen_res_data_pre     =   { { 32 { ex_wordgen_wordgen_src_data_i[31] } }, ex_wordgen_wordgen_src_data_i[31:0] };

    assign ex_wordgen_res_data_o    =   ex_wordgen_inst_word_i ? wordgen_res_data_pre: `ZERO_DWORD;
    
endmodule
