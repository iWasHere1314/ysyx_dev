`include "defines.v"
module id_control (
    input                       clk,
    input                       rst,


    input   [`INST_BUS]         id_control_inst_i,

    input   [`OPCODE_BUS]       id_control_opcode_i,
    input   [`FUNCT3_BUS]       id_control_funct3_i,
    input   [`FUNCT7_BUS]       id_control_funct7_i,
    
    /* id */
    output                      id_control_rs1_en_o,
    output                      id_control_rs2_en_o,
    output                      id_control_rd_en_o,
    output                      id_control_jump_base_pc_o,
    output  [`COMP_TYPE_BUS]    id_control_comp_type_o,
    output                      id_control_inst_jump_o,
    output                      id_control_inst_branch_o,
    output                      id_control_inst_lui_o,
    output  [`GEN_TYPE_BUS]     id_control_gen_type_o,

    /* ex */
    output                      id_control_inst_word_o,
    output                      id_control_inst_slt_nu_o,
    output                      id_control_inst_slt_u_o,
    output                      id_control_inst_shift_o,
    output                      id_control_alu_src_pc_o,
    output                      id_control_alu_src_imm_o,
    output                      id_control_shift_num_src_o,
    output  [`SHIFT_TYPE_BUS]   id_control_shift_type_o,
    output                      id_control_inst_arth_lgc_o,
    output                      id_control_inst_auipc_o,
    output  [`ALU_OP_BUS]       id_control_alu_op_o,

    /* mem */
    output                      id_control_inst_csr_o,
    output                      id_control_inst_load_o,
    output                      id_control_mem_write_o,
    output                      id_control_mem_read_o,
    output  [`STORE_TYPE_BUS]   id_control_store_type_o,
    output  [`LOAD_TYPE_BUS]    id_control_load_type_o,
    output                      id_control_csr_src_o,
    output  [`CSR_CTRL_BUS]     id_control_csr_ctrl_o,
    output                      id_control_inst_ecall_o,
    output                      id_control_inst_ebreak_o,
    output                      id_control_inst_mret_o,
    output                      id_control_inst_trap_o

    `ifdef DEFINE_PUTCH
    ,
    output                      id_control_inst_selfdefine_o
    `endif
);
    /* rename */
    wire    [`INST_BUS]         inst; 
    wire    [`OPCODE_BUS]       opcode;
    wire    [`FUNCT3_BUS]       funct3;
    wire    [`FUNCT7_BUS]       funct7;
    // id
    wire                        rs1_en;
    wire                        rs2_en;
    wire                        rd_en;
    wire                        jump_base_pc;
    wire    [`COMP_TYPE_BUS]    comp_type;
    wire                        inst_jump;
    wire                        inst_branch;
    wire                        inst_lui;
    wire    [`GEN_TYPE_BUS]     gen_type;

    // ex    
    wire                        inst_word;
    wire                        inst_slt_nu;
    wire                        inst_slt_u;
    wire                        inst_shift;
    wire                        alu_src_pc;
    wire                        alu_src_imm;
    wire                        shift_num_src;
    wire    [`SHIFT_TYPE_BUS]   shift_type;
    wire                        inst_arth_lgc;
    wire                        inst_auipc;
    wire    [`ALU_OP_BUS]       alu_op;

    // mem   
    wire                        inst_csr;
    wire                        inst_load;
    wire                        mem_write;
    wire                        mem_read;
    wire    [`STORE_TYPE_BUS]   store_type;
    wire    [`LOAD_TYPE_BUS]    load_type;
    wire                        csr_src;
    wire    [`CSR_CTRL_BUS]     csr_ctrl;
    wire                        inst_ecall;
    wire                        inst_ebreak;
    wire                        inst_mret;
    wire                        inst_trap;
    
    `ifdef DEFINE_PUTCH
    wire                        inst_selfdefine;
    `endif
    
    /* all instruction types */

    // wire                        inst_shift;
    // wire                        inst_lui;
    // wire                        inst_load;
    // wire                        inst_jump;    
    // wire                        inst_word;   
    // wire                        inst_branch;
    // wire                        inst_csr;
    // wire                        inst_auipc;
    // wire                        inst_slt_nu;
    // wire                        inst_slt_u;    
    // wire                        inst_trap;
    wire                            inst_store;
    wire                            inst_ali;
    wire                            inst_aliw;
    wire                            inst_al;
    wire                            inst_alw;

    wire                            inst_jal;
    wire                            inst_jalr;


    wire                            inst_mem;
    wire                            inst_alxx;
    wire                            inst_al_ni;
    wire                            inst_al_i;
    wire                            inst_al_nw;
    wire                            inst_al_w;
    wire                            inst_addxx;
    wire                            inst_subxx;
    wire                            inst_xorxx;
    wire                            inst_orxx;
    wire                            inst_andxx;
    wire                            inst_xuix;

    wire                            inst_csr_ni;
    wire                            inst_csr_i;
    wire                            inst_expt;
    /* all instructions */

    // wire                            inst_lui;
    // wire                            inst_auipc;
    // wire                            inst_jal;
    // wire                            inst_jalr;
    // wire                            inst_ecall;
    // wire                            inst_ebreak;
    // wire                            inst_mret;
    wire                            inst_beq;
    wire                            inst_bne;
    wire                            inst_blt;
    wire                            inst_bltu;
    wire                            inst_bge;
    wire                            inst_bgeu;
    wire                            inst_lb;
    wire                            inst_lh;
    wire                            inst_lw;
    wire                            inst_ld;
    wire                            inst_lbu;
    wire                            inst_lhu;
    wire                            inst_lwu;
    wire                            inst_sb;
    wire                            inst_sh;
    wire                            inst_sw;
    wire                            inst_sd;
    wire                            inst_addiw;
    wire                            inst_addi;
    wire                            inst_slti;
    wire                            inst_sltiu;
    wire                            inst_xori;
    wire                            inst_ori;
    wire                            inst_andi;
    wire                            inst_slliw;
    wire                            inst_slli;
    wire                            inst_srliw;
    wire                            inst_srli;
    wire                            inst_sraiw;
    wire                            inst_srai;
    wire                            inst_addw;
    wire                            inst_add;
    wire                            inst_subw;
    wire                            inst_sub;
    wire                            inst_sllw;
    wire                            inst_sll;
    wire                            inst_slt;
    wire                            inst_sltu;
    wire                            inst_xor;
    wire                            inst_srlw;
    wire                            inst_srl;
    wire                            inst_sraw;
    wire                            inst_sra;
    wire                            inst_or;
    wire                            inst_and;
    // wire                            inst_csrrw;
    // wire                            inst_csrrs;
    // wire                            inst_csrrc;
    // wire                            inst_csrrwi;
    // wire                            inst_csrrsi;
    // wire                            inst_csrrci; //不使用，因为控制信号直接用funct3

    `ifdef DEFINE_PUTCH
    assign inst_selfdefine              =   inst == 32'h7b;
    `endif

    wire [`EFF_OPCODE_BUS] eff_opcode = opcode[`EFF_OPCODE_LOC_BUS];

    
    /* rename assignments */
    assign inst                         =   id_control_inst_i; 
    assign opcode                       =   id_control_opcode_i;
    assign funct3                       =   id_control_funct3_i;
    assign funct7                       =   id_control_funct7_i;

    /* id */
    assign id_control_rs1_en_o          =   rs1_en;
    assign id_control_rs2_en_o          =   rs2_en;
    assign id_control_rd_en_o           =   rd_en;
    assign id_control_jump_base_pc_o    =   jump_base_pc;
    assign id_control_comp_type_o       =   comp_type;
    assign id_control_inst_jump_o       =   inst_jump;
    assign id_control_inst_branch_o     =   inst_branch;
    assign id_control_inst_lui_o        =   inst_lui;
    assign id_control_gen_type_o        =   gen_type;
    
    /* ex */
    assign id_control_inst_word_o       =   inst_word;
    assign id_control_inst_slt_nu_o     =   inst_slt_nu;
    assign id_control_inst_slt_u_o      =   inst_slt_u;
    assign id_control_inst_shift_o      =   inst_shift;
    assign id_control_alu_src_pc_o      =   alu_src_pc;
    assign id_control_alu_src_imm_o     =   alu_src_imm;
    assign id_control_shift_num_src_o   =   shift_num_src;
    assign id_control_shift_type_o      =   shift_type;
    assign id_control_inst_arth_lgc_o   =   inst_arth_lgc;
    assign id_control_inst_auipc_o      =   inst_auipc;
    assign id_control_alu_op_o          =   alu_op;

    /* mem */
    assign id_control_inst_csr_o        =   inst_csr;
    assign id_control_inst_load_o       =   inst_load;
    assign id_control_mem_write_o       =   mem_write;
    assign id_control_mem_read_o        =   mem_read;
    assign id_control_store_type_o      =   store_type;
    assign id_control_load_type_o       =   load_type;
    assign id_control_csr_src_o         =   csr_src;
    assign id_control_csr_ctrl_o        =   csr_ctrl;
    assign id_control_inst_ecall_o      =   inst_ecall;
    assign id_control_inst_ebreak_o     =   inst_ebreak;
    assign id_control_inst_mret_o       =   inst_mret;
    assign id_control_inst_trap_o       =   inst_trap;

    `ifdef DEFINE_PUTCH
    assign id_control_inst_selfdefine_o =   inst_selfdefine;
    `endif

    /* instruction type assignments*/
    assign inst_shift                   =   inst_alxx & ( funct3[1:0]==2'b01 );
    assign inst_lui                     =   eff_opcode == `EFF_OPCODE_LUI;
    assign inst_load                    =   eff_opcode == `EFF_OPCODE_LOAD;
    assign inst_jump                    =   inst_jal | inst_jalr;
    assign inst_word                    =   inst_aliw | inst_alw;
    assign inst_branch                  =   eff_opcode == `EFF_OPCODE_BRANCH;
    assign inst_csr                     =   eff_opcode == `EFF_OPCODE_CSR;
    assign inst_store                   =   eff_opcode == `EFF_OPCODE_STORE;
    assign inst_ali                     =   eff_opcode == `EFF_OPCODE_ALI;
    assign inst_aliw                    =   eff_opcode == `EFF_OPCODE_ALIW;
    assign inst_al                      =   eff_opcode == `EFF_OPCODE_AL;
    assign inst_alw                     =   eff_opcode == `EFF_OPCODE_ALW;
    assign inst_auipc                   =   eff_opcode == `EFF_OPCODE_AUIPC;
    assign inst_jal                     =   eff_opcode == `EFF_OPCODE_JAL;
    assign inst_jalr                    =   eff_opcode == `EFF_OPCODE_JALR;  
    assign inst_mem                     =   inst_load | inst_store;
    assign inst_arth_lgc                =   inst_alxx;
    assign inst_alxx                    =   inst_al_i | inst_al_ni;
    assign inst_al_ni                   =   inst_al | inst_alw;
    assign inst_al_i                    =   inst_ali | inst_aliw;
    assign inst_al_nw                   =   inst_al | inst_ali;
    assign inst_al_w                    =   inst_alw | inst_aliw;
    assign inst_addxx                   =   inst_add | inst_addi | inst_addw | inst_addiw;
    assign inst_subxx                   =   inst_sub | inst_subw;
    assign inst_xorxx                   =   inst_xor | inst_xori;
    assign inst_orxx                    =   inst_or | inst_ori;
    assign inst_andxx                   =   inst_and | inst_andi;
    assign inst_xuix                    =   inst_lui | inst_auipc;
    assign inst_slt_nu                  =   inst_slt | inst_slti;
    assign inst_slt_u                   =   inst_sltu | inst_sltiu;
    assign inst_csr_ni                  =   inst_csr & ( funct3[2] == 1'b0 ) & funct3[1:0] != 2'b00;
    assign inst_csr_i                   =   inst_csr & ( funct3[2] == 1'b1 ) & funct3[1:0] != 2'b00;
    assign inst_expt                    =   inst_csr & inst[`INST_19_7] == 13'b0;
    assign inst_trap                    =   inst_ecall | inst_ebreak | inst_mret;
    /* all instructions' assignments */
 
    // assign inst_lui                     = eff_opcode == `EFF_OPCODE_LUI;
    // assign inst_auipc                   = eff_opcode == `EFF_OPCODE_AUIPC;
    // assign inst_jal                     = eff_opcode == `EFF_OPCODE_JAL;
    // assign inst_jalr                    = eff_opcode == `EFF_OPCODE_JALR; 
    assign inst_ecall                   =   inst_expt & inst[`INST_31_20] == 12'b0;
    assign inst_ebreak                  =   inst_expt & inst[`INST_31_20] == 12'b1;
    assign inst_mret                    =   inst_expt & inst[`INST_31_20] == 12'h302;
    assign inst_beq                     =   inst_branch & ( funct3 == 3'b000 );
    assign inst_bne                     =   inst_branch & ( funct3 == 3'b001 );
    assign inst_blt                     =   inst_branch & ( funct3 == 3'b100 );
    assign inst_bltu                    =   inst_branch & ( funct3 == 3'b110 );
    assign inst_bge                     =   inst_branch & ( funct3 == 3'b101 );
    assign inst_bgeu                    =   inst_branch & ( funct3 == 3'b111 );
    assign inst_lb                      =   inst_load & ( funct3 == 3'b000 ) ;
    assign inst_lh                      =   inst_load & ( funct3 == 3'b001 ) ;
    assign inst_lw                      =   inst_load & ( funct3 == 3'b010 ) ;
    assign inst_ld                      =   inst_load & ( funct3 == 3'b011 ) ;
    assign inst_lbu                     =   inst_load & ( funct3 == 3'b100 ) ;
    assign inst_lhu                     =   inst_load & ( funct3 == 3'b101 ) ;
    assign inst_lwu                     =   inst_load & ( funct3 == 3'b110 ) ;//也是对称的诶
    assign inst_sb                      =   inst_store & ( funct3 == 3'b000 );
    assign inst_sh                      =   inst_store & ( funct3 == 3'b001 );
    assign inst_sw                      =   inst_store & ( funct3 == 3'b010 );
    assign inst_sd                      =   inst_store & ( funct3 == 3'b011 );
    assign inst_addiw                   =   inst_aliw & ( funct3 == 3'b000 );
    assign inst_addi                    =   inst_ali & ( funct3 == 3'b000 );
    assign inst_slti                    =   inst_ali & ( funct3 == 3'b010 );
    assign inst_sltiu                   =   inst_ali & ( funct3 == 3'b011 );
    assign inst_xori                    =   inst_ali & ( funct3 == 3'b100 );
    assign inst_ori                     =   inst_ali & ( funct3 == 3'b110 );
    assign inst_andi                    =   inst_ali & ( funct3 == 3'b111 );
    assign inst_slliw                   =   inst_aliw & ( funct3 == 3'b001 ) & ( funct7 == 7'b0000000 );
    assign inst_slli                    =   inst_ali & ( funct3 == 3'b001 ) & ( funct7[6:1] == 6'b000000 ) ;
    assign inst_srliw                   =   inst_aliw & ( funct3 == 3'b101 ) & ( funct7 == 7'b0000000 );
    assign inst_srli                    =   inst_ali & ( funct3 == 3'b101 ) & ( funct7[6:1] == 6'b000000 );
    assign inst_sraiw                   =   inst_aliw & ( funct3 == 3'b101 ) & ( funct7 == 7'b0100000 );
    assign inst_srai                    =   inst_ali & ( funct3 == 3'b101 ) & ( funct7[6:1] == 6'b010000 );
    assign inst_addw                    =   inst_alw & ( funct3 == 3'b000 ) & ( funct7 == 7'b0000000 );
    assign inst_add                     =   inst_al & ( funct3 == 3'b000 ) & ( funct7 == 7'b0000000 );
    assign inst_subw                    =   inst_alw & ( funct3 == 3'b000 ) & ( funct7 == 7'b0100000 );
    assign inst_sub                     =   inst_al & ( funct3 == 3'b000 ) & ( funct7 == 7'b0100000 );
    assign inst_sllw                    =   inst_alw & ( funct3 == 3'b001 ) & ( funct7 == 7'b0000000 );
    assign inst_sll                     =   inst_al & ( funct3 == 3'b001 ) & ( funct7 == 7'b0000000 );
    assign inst_slt                     =   inst_al & ( funct3 == 3'b010 ) & ( funct7 == 7'b0000000 );
    assign inst_sltu                    =   inst_al & ( funct3 == 3'b011 ) & ( funct7 == 7'b0000000 );
    assign inst_xor                     =   inst_al & ( funct3 == 3'b100 ) & ( funct7 == 7'b0000000 );
    assign inst_srlw                    =   inst_alw & ( funct3 == 3'b101 ) & ( funct7 == 7'b0000000 );
    assign inst_srl                     =   inst_al & ( funct3 == 3'b101 ) & ( funct7 == 7'b0000000 );
    assign inst_sraw                    =   inst_alw & ( funct3 == 3'b101 ) & ( funct7 == 7'b0100000 );
    assign inst_sra                     =   inst_al & ( funct3 == 3'b101 ) & ( funct7 == 7'b0100000 );
    assign inst_or                      =   inst_al & ( funct3 == 3'b110 ) & ( funct7 == 7'b0000000 );
    assign inst_and                     =   inst_al & ( funct3 == 3'b111 ) & ( funct7 == 7'b0000000 );

    /* all control signals' assignments */
    /* register control */
    assign rs1_en                       =   inst_jalr | inst_branch | inst_mem | inst_alxx | inst_csr_ni;
    assign rs2_en                       =   inst_branch | inst_store | inst_al_ni ;
    assign rd_en                        =   inst_xuix | inst_jump | inst_load | inst_alxx | inst_csr;
    assign jump_base_pc                 =   inst_jalr;

    /* instruction type */
    // assign inst_sltxx                   =   inst_slt | inst_sltu |inst_slti | inst_sltiu ;
    // assign inst_shift                   =   ( inst_al | inst_alw | inst_ali | inst_aliw ) & ( funct3[1:0]==2'b01 );
    // assign inst_lui                     =   eff_opcode == `EFF_OPCODE_LUI;
    // assign inst_load                    =   eff_opcode == `EFF_OPCODE_LOAD;
    // assign inst_jump                    =   inst_jal | inst_jalr;
    // assign inst_word                    =   inst_aliw | inst_alw;
    // assign inst_branch                  =   eff_opcode == `EFF_OPCODE_BRANCH;

    /* memory control */
    assign mem_write                    =   inst_store ;
    assign mem_read                     =   inst_load ;

    /* immediate number */
    assign gen_type                     =     ( { 3 { inst_store } } & 3'b011) 
                                            | ( { 3 { inst_xuix } } & 3'b100 )
                                            | ( { 3 { inst_jal } } & 3'b101 )
                                            | ( { 3 { inst_jalr | inst_load | ( inst_al_i & ~inst_shift ) } } & 3'b110 )
                                            | ( { 3 { inst_branch } } & 3'b111 )
                                            | ( { 3 { inst_shift } } & 3'b010 )
                                            | ( { 3 { inst_csr } } & 3'b001);

    /* alu control */
    assign alu_src_pc                   =   ~inst_auipc;
    assign alu_src_imm                  =   inst_auipc | inst_mem | ( inst_al_i & ~inst_shift ) ;
    assign alu_op                       =    ( { 3 { inst_auipc | inst_mem | inst_addxx } } & 3'b011 )  
                                           | ( { 3 { inst_slt_nu | inst_slt_u | inst_subxx } } & 3'b100)
                                           | ( { 3 { inst_xorxx } } & 3'b101 )
                                           | ( { 3 { inst_orxx } } & 3'b110 )
                                           | ( { 3 { inst_andxx } } & 3'b111);

    /* compare */
    assign comp_type                    =    ( { 3 { inst_beq } } & 3'b010 )
                                           | ( { 3 { inst_bne } } & 3'b011 )
                                           | ( { 3 { inst_blt } } & 3'b100 )
                                           | ( { 3 { inst_bltu } } & 3'b101 )
                                           | ( { 3 { inst_bge } } & 3'b110 )
                                           | ( { 3 { inst_bgeu } } & 3'b111 );          

    /* shift */
    assign shift_type                   =    ( { 3 { inst_sll | inst_slli } } & 3'b001 )
                                           | ( { 3 { inst_sllw | inst_slliw } } & 3'b011 )
                                           | ( { 3 { inst_srlw | inst_srliw } } & 3'b111 )
                                           | ( { 3 { inst_srl | inst_srli } } & 3'b101 )         
                                           | ( { 3 { inst_sraw | inst_sraiw} } & 3'b110 )
                                           | ( { 3 { inst_sra | inst_srai } } & 3'b100 );
    assign shift_num_src                =   ( inst_shift & inst_al_i );

    /* store */
    assign store_type                   =    ( { 3 { inst_sb } } & 3'b100 )
                                           | ( { 3 { inst_sh } } & 3'b101 )
                                           | ( { 3 { inst_sw } } & 3'b110 )
                                           | ( { 3 { inst_sd } } & 3'b111 );

    /* load */
    assign load_type                    =    ( { 3 { inst_lb } } & 3'b001 )
                                           | ( { 3 { inst_lbu } } & 3'b101 )
                                           | ( { 3 { inst_lh } } & 3'b010 )
                                           | ( { 3 { inst_lhu } } & 3'b110 )
                                           | ( { 3 { inst_lw } } & 3'b011 )
                                           | ( { 3 { inst_lwu } } & 3'b111 )
                                           | ( { 3 { inst_ld } } & 3'b100 );

    assign csr_ctrl                     =   inst_csr? funct3: 3'b100;
    assign csr_src                      =   funct3[2];
endmodule