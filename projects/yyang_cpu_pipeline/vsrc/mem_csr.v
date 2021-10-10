`include "defines.v"
module mem_csr(
    input                           clk,
    input                           rst,

    input                           mem_csr_inst_valid_i,

    input                           mem_csr_intp_en_i,

    input   [`CSR_INDEX_BUS]        mem_csr_csr_index_i,
    input   [`DATA_BUS]             mem_csr_rs1_data_i,
    input   [`DATA_BUS]             mem_csr_imm_csr_i,
    input   [`CSR_CTRL_BUS]         mem_csr_csr_ctrl_i,
    input   [`INST_ADDR_BUS]        mem_csr_inst_addr_i,
    input                           mem_csr_csr_src_i,
    input                           mem_csr_inst_trap_i,
    input                           mem_csr_inst_mret_i,
    input                           mem_csr_clint_mtip_i,
    input                           mem_csr_clint_update_i,
    input                           mem_csr_inst_ecall_i,
    input                           mem_csr_inst_ebreak_i,

    output                          mem_csr_csr_trap_o,
    output  [`INST_ADDR_BUS]        mem_csr_csr_nxt_pc_o,
    output  [`DATA_BUS]             mem_csr_csr_read_o
    `ifdef DEFINE_DIFFTEST
    ,
    output                          mem_csr_csr_skip_o,
    output  [`REG_BUS]              mem_csr_mstatus_o,
    output  [`REG_BUS]              mem_csr_mtvec_o,
    output  [`REG_BUS]              mem_csr_mepc_o,
    output  [`REG_BUS]              mem_csr_mcause_o,
    output  [`REG_BUS]              mem_csr_mip_o,
    output  [`REG_BUS]              mem_csr_mie_o,
    output  [`REG_BUS]              mem_csr_mscratch_o,
    output  [31:0]                  mem_csr_cause_o
    `endif
);
    /* index */
    wire                            index_mcycle;
    wire                            index_misa;
    wire                            index_mvendorid;
    wire                            index_marchid;
    wire                            index_mimpid;
    wire                            index_mhartid;
    wire                            index_mstatus;
    wire                            index_mtvec;
    wire                            index_mepc;
    wire                            index_mcause;
    wire                            index_mip;
    wire                            index_mie;
    wire                            index_mscratch;
    wire                            index_minstret; 

    /* control */  
    wire                            inst_csrrwx;
    wire                            inst_csrrsx;
    wire                            inst_csrrcx;
    wire                            trap_en;
    wire                            ret_en; 
    wire    [`DATA_BUS]             mcycle_nxt;
    wire    [`DATA_BUS]             minstret_nxt;
    wire                            trap_nmret;

    wire    [`DATA_BUS]             csr_nxt;
    wire    [`DATA_BUS]             csr_org;
    wire    [`DATA_BUS]             csr_writereference;
    wire    [`DATA_BUS]             csrrwx_res;
    wire    [`DATA_BUS]             csrrsx_res;
    wire    [`DATA_BUS]             csrrcx_res;

   
    /* reg */
    reg     [`DATA_BUS]             mcycle_r;
    wire    [`DATA_BUS]             misa_r;
    wire    [`DATA_BUS]             mvendorid_r;
    wire    [`DATA_BUS]             marchid_r;
    wire    [`DATA_BUS]             mimpid_r;
    wire    [`DATA_BUS]             mhartid_r;
    reg     [`DATA_BUS]             mstatus_r;
    reg     [`DATA_BUS]             mtvec_r;
    reg     [`INST_ADDR_BUS]        mepc_r;
    reg     [`DATA_BUS]             mcause_r;
    reg     [`DATA_BUS]             mip_r;
    reg     [`DATA_BUS]             mie_r;
    reg     [`DATA_BUS]             mscratch_r;
    reg     [`DATA_BUS]             minstret_r;

    assign index_mcycle             =   mem_csr_csr_index_i == `CSR_MCYCLE_INDEX;
    assign index_misa               =   mem_csr_csr_index_i == `CSR_MISA_INDEX;
    assign index_mvendorid          =   mem_csr_csr_index_i == `CSR_MVENDORID_INDEX;
    assign index_marchid            =   mem_csr_csr_index_i == `CSR_MARCHID_INDEX;
    assign index_mimpid             =   mem_csr_csr_index_i == `CSR_MIMPID_INDEX;
    assign index_mhartid            =   mem_csr_csr_index_i == `CSR_MHARTID_INDEX;    
    assign index_mstatus            =   mem_csr_csr_index_i == `CSR_MSTATUS_INDEX;
    assign index_mtvec              =   mem_csr_csr_index_i == `CSR_MTVEC_INDEX;
    assign index_mepc               =   mem_csr_csr_index_i == `CSR_MEPC_INDEX;
    assign index_mcause             =   mem_csr_csr_index_i == `CSR_MCAUSE_INDEX;
    assign index_mip                =   mem_csr_csr_index_i == `CSR_MIP_INDEX;
    assign index_mie                =   mem_csr_csr_index_i == `CSR_MIE_INDEX;
    assign index_mscratch           =   mem_csr_csr_index_i == `CSR_MSCRATCH_INDEX;    
    assign index_minstret           =   mem_csr_csr_index_i == `CSR_MINSTRET_INDEX;

    assign trap_nmret               =   (mem_csr_inst_trap_i & ~mem_csr_inst_mret_i) | mem_csr_intp_en_i;

    assign inst_csrrwx              =   mem_csr_csr_ctrl_i[1:0] == 2'b01;
    assign inst_csrrsx              =   mem_csr_csr_ctrl_i[1:0] == 2'b10;
    assign inst_csrrcx              =   mem_csr_csr_ctrl_i[1:0] == 2'b11;
    assign trap_en                  =   mem_csr_inst_valid_i & trap_nmret;
    assign ret_en                   =   mem_csr_inst_valid_i & mem_csr_inst_mret_i;
    assign minstret_nxt             =   minstret_r + `DATA_BUS_SIZE'h1;
    assign mcycle_nxt               =   mcycle_r + `DATA_BUS_SIZE'h1;

    assign csr_nxt                  =   { `DATA_BUS_SIZE { inst_csrrwx } } & csrrwx_res
                                        | { `DATA_BUS_SIZE { inst_csrrsx } } & csrrsx_res
                                        | { `DATA_BUS_SIZE { inst_csrrcx } } & csrrcx_res ;  

    assign csr_org                  =   { `DATA_BUS_SIZE { index_mcycle } } & ( mcycle_nxt )
                                        // | { `DATA_BUS_SIZE{ index_misa } } & ( misa_r )
                                        // | { `DATA_BUS_SIZE{ index_mvendorid } } & ( mvendorid_r )
                                        // | { `DATA_BUS_SIZE{ index_marchid } } & ( marchid_r )
                                        // | { `DATA_BUS_SIZE{ index_mimpid } } & ( mstatus_r )
                                        // | { `DATA_BUS_SIZE{ index_mhartid } } & ( mhartid_r )
                                        | { `DATA_BUS_SIZE{ index_mstatus } } & ( mstatus_r )
                                        | { `DATA_BUS_SIZE{ index_mtvec } } & ( mtvec_r )
                                        | { `DATA_BUS_SIZE{ index_mepc } } & ( mepc_r )
                                        | { `DATA_BUS_SIZE{ index_mcause } } & ( mcause_r )
                                        | { `DATA_BUS_SIZE{ index_mip } } & ( mip_r )
                                        | { `DATA_BUS_SIZE{ index_mscratch } } & ( mscratch_r )
                                        | { `DATA_BUS_SIZE{ index_minstret } } & ( minstret_nxt ); 

    assign csr_writereference       =   mem_csr_csr_src_i ? mem_csr_imm_csr_i: mem_csr_rs1_data_i;
    assign csrrwx_res               =   csr_writereference;
    assign csrrsx_res               =   csr_org | csr_writereference;    
    assign csrrcx_res               =   csr_org & ~csr_writereference;
    
    //mcycle
    always @( posedge clk ) begin
        if( rst ) begin
            mcycle_r <= `DATA_BUS_SIZE'b0;
        end
        else  if( index_mcycle & mem_csr_inst_valid_i )begin
            mcycle_r <= csr_nxt;
        end
        else begin
            mcycle_r <= mcycle_nxt;
        end
    end

    //misa
    assign misa_r                   =   { 2'b10, {`DATA_BUS_SIZE-28{1'b0}}, 26'h0100 };

    //mvendorid 
    assign mvendorid_r              =   `DATA_BUS_SIZE'b0;

    //marchid   
    assign marchid_r                =   `DATA_BUS_SIZE'b1;

    //mhartid   
    assign mhartid_r                =   `DATA_BUS_SIZE'b0;

    //mem_csr_mstatus_o
    always @( posedge clk ) begin
        if( rst ) begin
            mstatus_r <=  `DATA_BUS_SIZE'b0;
        end
        else if( index_mstatus & mem_csr_inst_valid_i ) begin
            mstatus_r <= { ( csr_nxt[16:15] == 2'b11 ) | ( csr_nxt[14:13] == 2'b11 ) ,csr_nxt[62:0] } /* & `DATA_BUS_SIZE'h1888 */;
        end
        else if( trap_en ) begin
            mstatus_r[12:11] <= 2'b11;
            mstatus_r[7] <= mstatus_r[3];
            mstatus_r[3] <= 1'b0;
        end
        else if( ret_en ) begin
            mstatus_r[12:11] <= 2'b00;
            mstatus_r[7] <= 1'b1;
            mstatus_r[3] <= mstatus_r[7];
        end
        else begin
            mstatus_r <= mstatus_r;
        end
    end 

    //mem_csr_mtvec_o
    always @( posedge clk ) begin
        if( rst ) begin
            mtvec_r <= `DATA_BUS_SIZE'h0;
        end
        else if( index_mtvec & mem_csr_inst_valid_i ) begin
            mtvec_r <= csr_nxt & ~64'h3;
        end
        else begin
            mtvec_r <= mtvec_r;
        end
    end

    //mem_csr_mepc_o
    always @( posedge clk ) begin
        if( rst ) begin
            mepc_r <= `DATA_BUS_SIZE'h0;
        end
        else if( index_mepc & mem_csr_inst_valid_i ) begin
            mepc_r <= csr_nxt;
        end
        else if( trap_en ) begin
            mepc_r <= mem_csr_inst_addr_i;
        end
        else begin
            mepc_r <= mepc_r;
        end
    end    

    //mem_csr_mcause_o
    always @( posedge clk ) begin
        if( rst ) begin
            mcause_r <= `DATA_BUS_SIZE'h0;
        end
        else if( mem_csr_inst_valid_i & index_mcause ) begin
            mcause_r <= csr_nxt;
        end
        else if( mem_csr_inst_ecall_i & mem_csr_inst_valid_i ) begin
            mcause_r <= `DATA_BUS_SIZE'd11; 
        end
        else if( mem_csr_inst_ebreak_i & mem_csr_inst_valid_i ) begin
            mcause_r <= `DATA_BUS_SIZE'd3;
        end
        else if( trap_en ) begin//确定不是ecall和break
            mcause_r <= ( `DATA_BUS_SIZE'h1<<(`DATA_BUS_SIZE-1) ) + `DATA_BUS_SIZE'h7;
        end
        else begin
            mcause_r <= mcause_r;
        end
    end

    //mem_csr_mip_o
    always @( posedge clk ) begin
        if( rst ) begin
            mip_r <= `DATA_BUS_SIZE'h0;
        end
        else if( index_mip & mem_csr_inst_valid_i ) begin
            mip_r <= csr_nxt & `DATA_BUS_SIZE'h80;
        end
        // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        else if( mem_csr_clint_mtip_i | mem_csr_clint_update_i ) begin
            mip_r[7] <= mem_csr_clint_mtip_i;
        end
        else begin
            mip_r <= mip_r;
        end
    end

    //mem_csr_mie_o
    always @( posedge clk ) begin
        if( rst ) begin
            mie_r <= `DATA_BUS_SIZE'h0;
        end
        else if( index_mie & mem_csr_inst_valid_i ) begin
            mie_r <= csr_nxt & `DATA_BUS_SIZE'h80;
        end
        else begin
            mie_r <= mie_r;
        end
    end

    //mem_csr_mscratch_o
    always @( posedge clk ) begin
        if( rst ) begin
            mscratch_r <= `DATA_BUS_SIZE'h0;
        end
        else if( index_mscratch & mem_csr_inst_valid_i ) begin
            mscratch_r <= csr_nxt;
        end
        else begin
            mscratch_r <= mscratch_r;
        end
    end

    //minstret
    always @( posedge clk ) begin
        if( rst ) begin
            minstret_r <= `DATA_BUS_SIZE'h0;
        end
        else if( index_minstret & mem_csr_inst_valid_i ) begin
            minstret_r <= csr_nxt;
        end
        else if( mem_csr_inst_valid_i ) begin
            minstret_r <= minstret_nxt;
        end
        else begin
            minstret_r <= minstret_r;
        end
    end


    //output
    assign mem_csr_csr_trap_o       =   mstatus_r[3] & ( mie_r[7] & mip_r[7] );
    assign mem_csr_csr_nxt_pc_o     =   trap_nmret ? mtvec_r: mepc_r;
    assign mem_csr_csr_read_o       =    { `DATA_BUS_SIZE { index_mcycle } } & ( mcycle_r )
                                       | { `DATA_BUS_SIZE{ index_misa } } & ( misa_r )
                                       | { `DATA_BUS_SIZE{ index_mvendorid } } & ( mvendorid_r )
                                       | { `DATA_BUS_SIZE{ index_marchid } } & ( marchid_r )
                                       | { `DATA_BUS_SIZE{ index_mimpid } } & ( mstatus_r )
                                       | { `DATA_BUS_SIZE{ index_mhartid } } & ( mhartid_r )
                                       | { `DATA_BUS_SIZE{ index_mstatus } } & ( mstatus_r )
                                       | { `DATA_BUS_SIZE{ index_mtvec } } & ( mtvec_r )
                                       | { `DATA_BUS_SIZE{ index_mepc } } & ( mepc_r )
                                       | { `DATA_BUS_SIZE{ index_mcause } } & ( mcause_r )
                                       | { `DATA_BUS_SIZE{ index_mip } } & ( mip_r )
                                       | { `DATA_BUS_SIZE{ index_mscratch } } & ( mscratch_r )
                                       | { `DATA_BUS_SIZE{ index_minstret } } & ( minstret_r ); 


    `ifdef DEFINE_DIFFTEST

    assign mem_csr_csr_skip_o       =   ~( index_mstatus | index_mtvec | index_mepc | index_mepc | index_mcause /* | index_mip */ | index_mie | index_mscratch | mem_csr_inst_ecall_i | mem_csr_inst_ebreak_i | mem_csr_inst_mret_i );
    assign mem_csr_mstatus_o        =   index_mstatus? { ( csr_nxt[16:15] == 2'b11 ) | ( csr_nxt[14:13] == 2'b11 ) ,csr_nxt[62:0] } /* & `DATA_BUS_SIZE'h1888 */: 
                                            trap_en? {mstatus_r[63:13], 2'b11, mstatus_r[10:8], mstatus_r[3],mstatus_r[6:4],1'b0,mstatus_r[2:0]}:
                                            ret_en? {mstatus_r[63:13], 2'b00, mstatus_r[10:8], 1'b1,mstatus_r[6:4],mstatus_r[7],mstatus_r[2:0]}:
                                            mstatus_r;
    assign mem_csr_mtvec_o          =   index_mtvec? csr_nxt & ~64'h3: mtvec_r;
    assign mem_csr_mepc_o           =   index_mepc? csr_nxt:
                                            trap_nmret? mem_csr_inst_addr_i:
                                            mepc_r ;
    assign mem_csr_mcause_o         =   index_mcause? csr_nxt: 
                                            mem_csr_inst_ecall_i? `DATA_BUS_SIZE'd11: 
                                            mem_csr_inst_ebreak_i? `DATA_BUS_SIZE'd3:
                                            trap_nmret? ( `DATA_BUS_SIZE'h1<<(`DATA_BUS_SIZE-1) ) + `DATA_BUS_SIZE'h7: 
                                            mcause_r;
    assign mem_csr_mip_o            =   index_mip? csr_nxt & `DATA_BUS_SIZE'h80:
                                            mem_csr_clint_mtip_i? { mip_r[63:8], 1'b1, mip_r[6:0] }:
                                            mip_r;
    assign mem_csr_mie_o            =   index_mie? csr_nxt & `DATA_BUS_SIZE'h80: mie_r;
    assign mem_csr_mscratch_o       =   index_mscratch? csr_nxt: mscratch_r;
    assign mem_csr_cause_o          =   { mem_csr_mcause_o[`DATA_BUS_SIZE-1], mem_csr_mcause_o[30:0] }; 

    `endif
    
endmodule
