`include "defines.v"
module ex_shifter (
    /* control signals */
    // shift          
    input                       inst_shift,
    input   [`SHIFT_TYPE_BUS]   shift_type,
    input                       shift_num_src,
    
    /* data */
    input   [`DATA_BUS]         rs1_data,
    input   [`DATA_BUS]         rs2_data,
    input   [`IMM_SHIFT_BUS]    imm_shift,

    /* output */
    output  [`DATA_BUS]         shifter_res
);
    wire shift_word;
    wire shift_sllx;
    wire shift_srxx;
    wire shift_srax;
    wire shift_srlx;
    wire shift_srl;
    wire shift_srlw;

    wire [`IMM_SHIFT_BUS]   shift_num_pre;
    wire [`IMM_SHIFT_BUS]   shift_num_eff;
    wire [`DATA_BUS]        shift_src;
    wire [`DATA_BUS]        shift_src_pre;
    wire [`DATA_BUS]        shift_res;
    wire [`DATA_BUS]        shift_sllx_res;
    wire [`DATA_BUS]        shift_srax_res;
    wire [`DATA_BUS]        shift_srlx_res;
    wire [`DATA_BUS]        shift_eff_mask;

    assign shift_word       =   shift_type[2:1] == 2'b11;
    assign shift_sllx       =   shift_type      == 3'b011;
    assign shift_srxx       =   shift_type[2]   == 1'b1;
    assign shift_srax       =   shift_srxx & ( shift_type[0] == 1'b0 ); 
    assign shift_srlx       =   shift_srxx & ( shift_type[0] == 1'b1 );
    assign shift_srl        =   shift_srlx & ~shift_word;
    assign shift_srlw       =   shift_srlx & shift_word;

    assign shift_num_pre    =   shift_num_src? imm_shift: rs2_data[`IMM_SHIFT_BUS];
    assign shift_num_eff    =   shift_word? { 1'b0, shift_num_pre[4:0] }: shift_num_pre;
    
    assign shift_src_pre    =   shift_srlw && ( shift_num_eff != 1'b0 )? { 32'b0, rs1_data[31:0] }: rs1_data;
        // shifter的输入已经进行了字扩展， 只有进行srlw操作且位数不为0时才会出现扩展位一定是0的情况。
        // 其他情况下符号位一定与扩展出的高位一致，而最高位的问题将由后续的字扩展解决。
    // 此处实现参考了E203
    assign shift_src        =   shift_srxx? { shift_src_pre[00], shift_src_pre[01], shift_src_pre[02], shift_src_pre[03], 
                                              shift_src_pre[04], shift_src_pre[05], shift_src_pre[06], shift_src_pre[07], 
                                              shift_src_pre[08], shift_src_pre[09], shift_src_pre[10], shift_src_pre[11], 
                                              shift_src_pre[12], shift_src_pre[13], shift_src_pre[14], shift_src_pre[15],
                                              shift_src_pre[16], shift_src_pre[17], shift_src_pre[18], shift_src_pre[19],
                                              shift_src_pre[20], shift_src_pre[21], shift_src_pre[22], shift_src_pre[23],
                                              shift_src_pre[24], shift_src_pre[25], shift_src_pre[26], shift_src_pre[27], 
                                              shift_src_pre[28], shift_src_pre[29], shift_src_pre[30], shift_src_pre[31],
                                              shift_src_pre[32], shift_src_pre[33], shift_src_pre[34], shift_src_pre[35],
                                              shift_src_pre[36], shift_src_pre[37], shift_src_pre[38], shift_src_pre[39],
                                              shift_src_pre[40], shift_src_pre[41], shift_src_pre[42], shift_src_pre[43],
                                              shift_src_pre[44], shift_src_pre[45], shift_src_pre[46], shift_src_pre[47],
                                              shift_src_pre[48], shift_src_pre[49], shift_src_pre[50], shift_src_pre[51],
                                              shift_src_pre[52], shift_src_pre[53], shift_src_pre[54], shift_src_pre[55],
                                              shift_src_pre[56], shift_src_pre[57], shift_src_pre[58], shift_src_pre[59],
                                              shift_src_pre[60], shift_src_pre[61], shift_src_pre[62], shift_src_pre[63]
                                            }
                                            : shift_src_pre;                                   
    assign shift_res        =   shift_src << shift_num_eff;
    assign shift_sllx_res   =   shift_res;
    assign shift_srlx_res   =   { shift_res[00], shift_res[01], shift_res[02], shift_res[03], 
                                  shift_res[04], shift_res[05], shift_res[06], shift_res[07], 
                                  shift_res[08], shift_res[09], shift_res[10], shift_res[11], 
                                  shift_res[12], shift_res[13], shift_res[14], shift_res[15],
                                  shift_res[16], shift_res[17], shift_res[18], shift_res[19],
                                  shift_res[20], shift_res[21], shift_res[22], shift_res[23],
                                  shift_res[24], shift_res[25], shift_res[26], shift_res[27], 
                                  shift_res[28], shift_res[29], shift_res[30], shift_res[31],
                                  shift_res[32], shift_res[33], shift_res[34], shift_res[35],
                                  shift_res[36], shift_res[37], shift_res[38], shift_res[39],
                                  shift_res[40], shift_res[41], shift_res[42], shift_res[43],
                                  shift_res[44], shift_res[45], shift_res[46], shift_res[47],
                                  shift_res[48], shift_res[49], shift_res[50], shift_res[51],
                                  shift_res[52], shift_res[53], shift_res[54], shift_res[55],
                                  shift_res[56], shift_res[57], shift_res[58], shift_res[59],
                                  shift_res[60], shift_res[61], shift_res[62], shift_res[63]
                                };
    assign shift_srax_res   = shift_word? shift_srlx_res: ( ( shift_srlx_res & shift_eff_mask ) | ( { `DATA_BUS_SIZE { shift_srlx_res[63] } } & ~shift_eff_mask ) );
    assign shift_eff_mask   = ( ~( `DATA_BUS_SIZE'b0) ) >> shift_num_eff;

    assign shifter_res      = `ZERO_DWORD | ( { 64 { shift_sllx } } & shift_sllx_res ) 
                                          | ( { 64 { shift_srax } } & shift_srax_res )
                                          | ( { 64 { shift_srlx } } & shift_srlx_res );  
endmodule