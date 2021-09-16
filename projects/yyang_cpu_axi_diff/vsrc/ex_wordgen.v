`include "defines.v"
module ex_wordgen (
    /* control signals */
    input                       inst_word, 

    /* data */
    input   [`DATA_BUS]         wordgen_idata,

    /* output */
    output  [`DATA_BUS]         wordgen_res_data
);
    wire [`DATA_BUS]    wordgen_res_data_pre;

    assign wordgen_res_data_pre     =   { { 32 { wordgen_idata[31] } }, wordgen_idata[31:0] };

    assign wordgen_res_data         =   inst_word ? wordgen_res_data_pre: `ZERO_DWORD;
    
endmodule
