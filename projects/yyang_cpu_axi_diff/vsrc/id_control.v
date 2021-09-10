`include "defines.v"

module id_control (
    `ifdef DEFINE_PUTCH
    input   [`INST_BUS]         inst,
    `endif 

    input   [`OPCODE_BUS]       opcode,
    input   [`FUNCT3_BUS]       funct3,
    input   [`FUNCT7_BUS]       funct7,
    
    /* interrupt */
    input                       csr_trap,

    /* register control */
    output                      rs1_en,
    output                      rs2_en,
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
    output                      inst_ecall,
    output                      inst_ebreak,
    output                      inst_trap,
    output                      inst_mret,
    /* memory control */
    output                      mem_write,
    output                      mem_read,

    /* immediate number */
    output  [`GEN_TYPE_BUS]     gen_type,

    /* alu control */
    output                      alu_src_pc,
    output                      alu_src_imm,
    output  [`ALU_OP_BUS]       alu_op,

    /* compare */
    output [`COMP_TYPE_BUS]     comp_type,

    /* shift */
    output [`SHIFT_TYPE_BUS]    shift_type,
    output                      shift_num_src,

    /* store */
    output [`STORE_TYPE_BUS]    store_type,

    /* load */
    output [`LOAD_TYPE_BUS]     load_type,

    /* csr */
    output [`CSR_CTRL_BUS]      csr_ctrl,
    output                      csr_src

    /* instruction */
    `ifdef DEFINE_PUTCH
    ,
    output                      inst_selfdefine
    `endif
);
    
    /* interrupt */

    /* all instruction types */

    // wire inst_sltxx;
    // wire inst_shift;
    // wire inst_lui;
    // wire inst_load;
    // wire inst_jump;    
    // wire inst_word;   
    // wire inst_branch;
    // wire inst_csr;
    // wire inst_trap;

    wire inst_store;
    wire inst_ali;
    wire inst_aliw;
    wire inst_al;
    wire inst_alw;
    wire inst_auipc;
    wire inst_jal;
    wire inst_jalr;
    

    wire inst_mem;
    wire inst_alxx;
    wire inst_al_ni;
    wire inst_al_i;
    wire inst_al_nw;
    wire inst_al_w;
    wire inst_addxx;
    wire inst_subxx;
    wire inst_xorxx;
    wire inst_orxx;
    wire inst_andxx;
    wire inst_xuix;
    wire inst_slt_nu;
    wire inst_slt_u;
    wire inst_csr_ni;
    wire inst_csr_i;
    wire inst_expt;
    /* all instructions */

    // wire inst_lui;
    // wire inst_auipc;
    // wire inst_jal;
    // wire inst_jalr;
    // wire inst_ecall;
    // wire inst_ebreak;
    // wire inst_mret;
    wire inst_beq;
    wire inst_bne;
    wire inst_blt;
    wire inst_bltu;
    wire inst_bge;
    wire inst_bgeu;
    wire inst_lb;
    wire inst_lh;
    wire inst_lw;
    wire inst_ld;
    wire inst_lbu;
    wire inst_lhu;
    wire inst_lwu;
    wire inst_sb;
    wire inst_sh;
    wire inst_sw;
    wire inst_sd;
    wire inst_addiw;
    wire inst_addi;
    wire inst_slti;
    wire inst_sltiu;
    wire inst_xori;
    wire inst_ori;
    wire inst_andi;
    wire inst_slliw;
    wire inst_slli;
    wire inst_srliw;
    wire inst_srli;
    wire inst_sraiw;
    wire inst_srai;
    wire inst_addw;
    wire inst_add;
    wire inst_subw;
    wire inst_sub;
    wire inst_sllw;
    wire inst_sll;
    wire inst_slt;
    wire inst_sltu;
    wire inst_xor;
    wire inst_srlw;
    wire inst_srl;
    wire inst_sraw;
    wire inst_sra;
    wire inst_or;
    wire inst_and;
    // wire inst_csrrw;
    // wire inst_csrrs;
    // wire inst_csrrc;
    // wire inst_csrrwi;
    // wire inst_csrrsi;
    // wire inst_csrrci; //不使用，因为控制信号直接用funct3

    `ifdef DEFINE_PUTCH
    assign inst_selfdefine = inst == 32'h7b;
    `endif
    
    wire [`EFF_OPCODE_BUS] eff_opcode = opcode[`EFF_OPCODE_LOC_BUS];

      
    /* instruction type assignments*/
    assign inst_sltxx   =   inst_slt_nu | inst_slt_u ;
    assign inst_shift   =   inst_alxx & ( funct3[1:0]==2'b01 );
    assign inst_lui     =   eff_opcode == `EFF_OPCODE_LUI;
    assign inst_load    =   eff_opcode == `EFF_OPCODE_LOAD;
    assign inst_jump    =   inst_jal | inst_jalr;
    assign inst_word    =   inst_aliw | inst_alw;
    assign inst_branch  =   eff_opcode == `EFF_OPCODE_BRANCH;
    assign inst_csr     =   eff_opcode == `EFF_OPCODE_CSR;
    assign inst_trap    =   csr_trap | inst_ecall | inst_ebreak;
    assign inst_store   =   eff_opcode == `EFF_OPCODE_STORE;
    assign inst_ali     =   eff_opcode == `EFF_OPCODE_ALI;
    assign inst_aliw    =   eff_opcode == `EFF_OPCODE_ALIW;
    assign inst_al      =   eff_opcode == `EFF_OPCODE_AL;
    assign inst_alw     =   eff_opcode == `EFF_OPCODE_ALW;
    assign inst_auipc   =   eff_opcode == `EFF_OPCODE_AUIPC;
    assign inst_jal     =   eff_opcode == `EFF_OPCODE_JAL;
    assign inst_jalr    =   eff_opcode == `EFF_OPCODE_JALR;  
    assign inst_mem     =   inst_load | inst_store;
    assign inst_alxx    =   inst_al_i | inst_al_ni;
    assign inst_al_ni   =   inst_al | inst_alw;
    assign inst_al_i    =   inst_ali | inst_aliw;
    assign inst_al_nw   =   inst_al | inst_ali;
    assign inst_al_w    =   inst_alw | inst_aliw;
    assign inst_addxx   =   inst_add | inst_addi | inst_addw | inst_addiw;
    assign inst_subxx   =   inst_sub | inst_subw;
    assign inst_xorxx   =   inst_xor | inst_xori;
    assign inst_orxx    =   inst_or | inst_ori;
    assign inst_andxx   =   inst_and | inst_andi;
    assign inst_xuix    =   inst_lui | inst_auipc;
    assign inst_slt_nu  =   inst_slt | inst_slti;
    assign inst_slt_u   =   inst_sltu | inst_sltiu;
    assign inst_csr_ni  =   inst_csr & ( funct3[2] == 1'b0 ) & funct3[1:0] != 2'b00;
    assign inst_csr_i   =   inst_csr & ( funct3[2] == 1'b1 ) & funct3[1:0] != 2'b00;
    assign inst_expt    =   inst_csr & inst[`INST_19_7] == 13'b0;
    /* all instructions' assignments */

    // assign inst_lui     = eff_opcode == `EFF_OPCODE_LUI;
    // assign inst_auipc   = eff_opcode == `EFF_OPCODE_AUIPC;
    // assign inst_jal     = eff_opcode == `EFF_OPCODE_JAL;
    // assign inst_jalr    = eff_opcode == `EFF_OPCODE_JALR;  
    assign inst_ecall   =   inst_expt & inst[`INST_31_20] == 12'b0;
    assign inst_ebreak  =   inst_expt & inst[`INST_31_20] == 12'b1;
    assign inst_mret    =   inst_expt & inst[`INST_31_20] == 12'h302;
    assign inst_beq     =   inst_branch & ( funct3 == 3'b000 );
    assign inst_bne     =   inst_branch & ( funct3 == 3'b001 );
    assign inst_blt     =   inst_branch & ( funct3 == 3'b100 );
    assign inst_bltu    =   inst_branch & ( funct3 == 3'b110 );
    assign inst_bge     =   inst_branch & ( funct3 == 3'b101 );
    assign inst_bgeu    =   inst_branch & ( funct3 == 3'b111 );
    assign inst_lb      =   inst_load & ( funct3 == 3'b000 ) ;
    assign inst_lh      =   inst_load & ( funct3 == 3'b001 ) ;
    assign inst_lw      =   inst_load & ( funct3 == 3'b010 ) ;
    assign inst_ld      =   inst_load & ( funct3 == 3'b011 ) ;
    assign inst_lbu     =   inst_load & ( funct3 == 3'b100 ) ;
    assign inst_lhu     =   inst_load & ( funct3 == 3'b101 ) ;
    assign inst_lwu     =   inst_load & ( funct3 == 3'b110 ) ;//也是对称的诶
    assign inst_sb      =   inst_store & ( funct3 == 3'b000 );
    assign inst_sh      =   inst_store & ( funct3 == 3'b001 );
    assign inst_sw      =   inst_store & ( funct3 == 3'b010 );
    assign inst_sd      =   inst_store & ( funct3 == 3'b011 );
    assign inst_addiw   =   inst_aliw & ( funct3 == 3'b000 );
    assign inst_addi    =   inst_ali & ( funct3 == 3'b000 );
    assign inst_slti    =   inst_ali & ( funct3 == 3'b010 );
    assign inst_sltiu   =   inst_ali & ( funct3 == 3'b011 );
    assign inst_xori    =   inst_ali & ( funct3 == 3'b100 );
    assign inst_ori     =   inst_ali & ( funct3 == 3'b110 );
    assign inst_andi    =   inst_ali & ( funct3 == 3'b111 );
    assign inst_slliw   =   inst_aliw & ( funct3 == 3'b001 ) & ( funct7 == 7'b0000000 );
    assign inst_slli    =   inst_ali & ( funct3 == 3'b001 ) & ( funct7[6:1] == 6'b000000 ) ;
    assign inst_srliw   =   inst_aliw & ( funct3 == 3'b101 ) & ( funct7 == 7'b0000000 );
    assign inst_srli    =   inst_ali & ( funct3 == 3'b101 ) & ( funct7[6:1] == 6'b000000 );
    assign inst_sraiw   =   inst_aliw & ( funct3 == 3'b101 ) & ( funct7 == 7'b0100000 );
    assign inst_srai    =   inst_ali & ( funct3 == 3'b101 ) & ( funct7[6:1] == 6'b010000 );
    assign inst_addw    =   inst_alw & ( funct3 == 3'b000 ) & ( funct7 == 7'b0000000 );
    assign inst_add     =   inst_al & ( funct3 == 3'b000 ) & ( funct7 == 7'b0000000 );
    assign inst_subw    =   inst_alw & ( funct3 == 3'b000 ) & ( funct7 == 7'b0100000 );
    assign inst_sub     =   inst_al & ( funct3 == 3'b000 ) & ( funct7 == 7'b0100000 );
    assign inst_sllw    =   inst_alw & ( funct3 == 3'b001 ) & ( funct7 == 7'b0000000 );
    assign inst_sll     =   inst_al & ( funct3 == 3'b001 ) & ( funct7 == 7'b0000000 );
    assign inst_slt     =   inst_al & ( funct3 == 3'b010 ) & ( funct7 == 7'b0000000 );
    assign inst_sltu    =   inst_al & ( funct3 == 3'b011 ) & ( funct7 == 7'b0000000 );
    assign inst_xor     =   inst_al & ( funct3 == 3'b100 ) & ( funct7 == 7'b0000000 );
    assign inst_srlw    =   inst_alw & ( funct3 == 3'b101 ) & ( funct7 == 7'b0000000 );
    assign inst_srl     =   inst_al & ( funct3 == 3'b101 ) & ( funct7 == 7'b0000000 );
    assign inst_sraw    =   inst_alw & ( funct3 == 3'b101 ) & ( funct7 == 7'b0100000 );
    assign inst_sra     =   inst_al & ( funct3 == 3'b101 ) & ( funct7 == 7'b0100000 );
    assign inst_or      =   inst_al & ( funct3 == 3'b110 ) & ( funct7 == 7'b0000000 );
    assign inst_and     =   inst_al & ( funct3 == 3'b111 ) & ( funct7 == 7'b0000000 );

    /* all control signals' assignments */
    /* register control */
    assign rs1_en       =   1'b0 | inst_jalr | inst_branch | inst_mem | inst_alxx | inst_csr_ni;
    assign rs2_en       =   1'b0 | inst_branch | inst_store | inst_al_ni ;
    assign rd_en        =   1'b0 | inst_xuix | inst_jump | inst_load | inst_alxx | inst_csr;

    /* instruction type */
    // assign inst_sltxx   =   inst_slt | inst_sltu |inst_slti | inst_sltiu ;
    // assign inst_shift   =   ( inst_al | inst_alw | inst_ali | inst_aliw ) & ( funct3[1:0]==2'b01 );
    // assign inst_lui     =   eff_opcode == `EFF_OPCODE_LUI;
    // assign inst_load    =   eff_opcode == `EFF_OPCODE_LOAD;
    // assign inst_jump    =   inst_jal | inst_jalr;
    // assign inst_word    =   inst_aliw | inst_alw;
    // assign inst_branch  =   eff_opcode == `EFF_OPCODE_BRANCH;

    /* memory control */
    assign mem_write    =   1'b0 | inst_store ;
    assign mem_read     =   1'b0 | inst_load ;

    /* immediate number */
    assign gen_type     =   3'b000 | ( { 3 { inst_store } } & 3'b011) 
                                   | ( { 3 { inst_xuix } } & 3'b100 )
                                   | ( { 3 { inst_jal } } & 3'b101 )
                                   | ( { 3 { inst_jalr | inst_load | ( inst_al_i & ~inst_shift ) } } & 3'b110 )
                                   | ( { 3 { inst_branch } } & 3'b111 );

    /* alu control */
    assign alu_src_pc   =   1'b1 & ( ~inst_auipc ) & ( ~inst_jal );
    assign alu_src_imm  =   1'b0 | inst_auipc | inst_jump | inst_mem | ( inst_al_i & ~inst_shift ) ;
    assign alu_op       =   3'b000 | ( { 3 { inst_auipc | inst_jump | inst_mem | inst_addxx } } & 3'b011 )  
                                   | ( { 3 { inst_branch | inst_sltxx | inst_subxx } } & 3'b100)
                                   | ( { 3 { inst_xorxx } } & 3'b101 )
                                   | ( { 3 { inst_orxx } } & 3'b110 )
                                   | ( { 3 { inst_andxx } } & 3'b111);

    /* compare */
    assign comp_type    =   3'b000 | ( { 3 { inst_beq } } & 3'b010 )
                                   | ( { 3 { inst_bne } } & 3'b011 )
                                   | ( { 3 { inst_blt | inst_slt_nu } } & 3'b100 )
                                   | ( { 3 { inst_bltu | inst_slt_u} } & 3'b101 )
                                   | ( { 3 { inst_bge } } & 3'b110 )
                                   | ( { 3 { inst_bgeu } } & 3'b111 );          

    /* shift */
    assign shift_type   =   3'b000 | ( { 3 { inst_sll | inst_slli } } & 3'b001 )
                                   | ( { 3 { inst_sllw | inst_slliw } } & 3'b011 )
                                   | ( { 3 { inst_srlw | inst_srliw } } & 3'b111 )
                                   | ( { 3 { inst_srl | inst_srli } } & 3'b101 )         
                                   | ( { 3 { inst_sraw | inst_sraiw} } & 3'b110 )
                                   | ( { 3 { inst_sra | inst_srai } } & 3'b100 );
    assign shift_num_src=   1'b0 | ( inst_shift & inst_al_i );

    /* store */
    assign store_type   =   3'b000 | ( { 3 { inst_sb } } & 3'b100 )
                                   | ( { 3 { inst_sh } } & 3'b101 )
                                   | ( { 3 { inst_sw } } & 3'b110 )
                                   | ( { 3 { inst_sd } } & 3'b111 );

    /* load */
    assign load_type    =   3'b000 | ( { 3 { inst_lb } } & 3'b001 )
                                   | ( { 3 { inst_lbu } } & 3'b101 )
                                   | ( { 3 { inst_lh } } & 3'b010 )
                                   | ( { 3 { inst_lhu } } & 3'b110 )
                                   | ( { 3 { inst_lw } } & 3'b011 )
                                   | ( { 3 { inst_lwu } } & 3'b111 )
                                   | ( { 3 { inst_ld } } & 3'b100 );
    
    assign csr_ctrl     =   inst_csr? funct3: 3'b100;
    assign csr_src      =   funct3[2];
    
endmodule