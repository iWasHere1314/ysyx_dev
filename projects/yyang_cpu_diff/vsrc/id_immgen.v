`include "defines.v"
module id_immgen (
    input   [`INST_BUS]         inst,
    input   [`GEN_TYPE_BUS]     gen_type,
    output  [`DATA_BUS]         imm_data,
    output  [`IMM_SHIFT_BUS]    imm_shift
);
    wire inst_store;
    wire inst_xuix;
    wire inst_jal;
    wire inst_jalr_load_ali;
    wire inst_branch;
    wire [`IMM_PRE_BUS] imm_store;
    wire [`IMM_PRE_BUS] imm_xuix;
    wire [`IMM_PRE_BUS] imm_jal;
    wire [`IMM_PRE_BUS] imm_jalr_load_ali;
    wire [`IMM_PRE_BUS] imm_branch;
    wire [`IMM_PRE_BUS] imm_pre;

    assign inst_store           =   gen_type == 3'b011;
    assign inst_xuix            =   gen_type == 3'b100;
    assign inst_jal             =   gen_type == 3'b101;
    assign inst_jalr_load_ali   =   gen_type == 3'b110;
    assign inst_branch          =   gen_type == 3'b111;

    assign imm_store            =   { { 20 { inst[`INST_31]} }, inst[`INST_31_25], 
                                        inst[`INST_11_7] };

    assign imm_xuix             =   { inst[`INST_31_12], 12'b0 };

    assign imm_jal              =   { { 11 { inst[`INST_31] } }, inst[`INST_31],
                                        inst[`INST_19_12], inst[`INST_20],
                                        inst[`INST_30_21], 1'b0 };

    assign imm_jalr_load_ali    =   {  { 20 { inst[`INST_31] } }, inst[`INST_31_20] };

    assign imm_branch           =   {  { 19 { inst[`INST_31] } }, inst[`INST_31],
                                        inst[`INST_7], inst[`INST_30_25], 
                                        inst[`INST_11_8], 1'b0 };

    assign imm_pre              =   32'b0 | ( { 32 { inst_store } } & imm_store )
                                          | ( { 32 { inst_xuix } } & imm_xuix )
                                          | ( { 32 { inst_jal } } & imm_jal )
                                          | ( { 32 { inst_jalr_load_ali } } & imm_jalr_load_ali )
                                          | ( { 32 { inst_branch } } & imm_branch );

    assign imm_data             =   64'h9000;  
    
    assign imm_shift            =   inst[`INST_25_20];
                                 
endmodule