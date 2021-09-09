`include "defines.v"
module csr_top (
    input                           clk,
    input                           rst,

    input                           inst_valid,
    input   [`CSR_INDEX_BUS]        csr_index,
    input   [`DATA_BUS]             rs1_data,
    input   [`DATA_BUS]             imm_csr,
    input   [`CSR_CTRL_BUS]         csr_ctrl,
    input   [`INST_ADDR_BUS]        inst_addr,
    input                           csr_src,
    input                           inst_trap,
    input                           inst_mret,
    input                           clint_mtip,
    input                           inst_ecall,
    input                           inst_ebreak,

    output                          csr_trap,
    output  [`INST_ADDR_BUS]        csr_nxt_pc,
    output  [`DATA_BUS]             csr_read
    `ifdef DEFINE_DIFFTEST
                                            ,
    // output                          csr_skip
    output  [`REG_BUS]              mstatus,
    output  [`REG_BUS]              mtvec,
    output  [`REG_BUS]              mepc,
    output  [`REG_BUS]              mcause,
    output  [`REG_BUS]              mip,
    output  [`REG_BUS]              mie,
    output  [`REG_BUS]              mscratch    
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

    assign index_mcycle         =   csr_index == `CSR_MCYCLE_INDEX;
    assign index_misa           =   csr_index == `CSR_MISA_INDEX;
    assign index_mvendorid      =   csr_index == `CSR_MVENDORID_INDEX;
    assign index_marchid        =   csr_index == `CSR_MARCHID_INDEX;
    assign index_mimpid         =   csr_index == `CSR_MIMPID_INDEX;
    assign index_mhartid        =   csr_index == `CSR_MHARTID_INDEX;    
    assign index_mstatus        =   csr_index == `CSR_MSTATUS_INDEX;
    assign index_mtvec          =   csr_index == `CSR_MTVEC_INDEX;
    assign index_mepc           =   csr_index == `CSR_MEPC_INDEX;
    assign index_mcause         =   csr_index == `CSR_MCAUSE_INDEX;
    assign index_mip            =   csr_index == `CSR_MIP_INDEX;
    assign index_mie            =   csr_index == `CSR_MIE_INDEX;
    assign index_mscratch       =   csr_index == `CSR_MSCRATCH_INDEX;    
    assign index_minstret       =   csr_index == `CSR_MINSTRET_INDEX;

    assign inst_csrrwx          =   csr_ctrl[1:0] == 2'b01;
    assign inst_csrrsx          =   csr_ctrl[1:0] == 2'b10;
    assign inst_csrrcx          =   csr_ctrl[1:0] == 2'b11;
    assign trap_en              =   inst_valid & inst_trap;
    assign ret_en               =   inst_valid & inst_mret;
    assign minstret_nxt         =   minstret_r + `DATA_BUS_SIZE'h1;
    assign mcycle_nxt           =   mcycle_r + `DATA_BUS_SIZE'h1;

    assign csr_nxt              =   { `DATA_BUS_SIZE { inst_csrrwx } } & csrrwx_res
                                    | { `DATA_BUS_SIZE { inst_csrrsx } } & csrrsx_res
                                    | { `DATA_BUS_SIZE { inst_csrrcx } } & csrrcx_res ;  
    
    assign csr_org              =   { `DATA_BUS_SIZE { index_mcycle } } & ( mcycle_nxt )
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

    assign csr_writereference   =   csr_src ? imm_csr: rs1_data;
    assign csrrwx_res           =   csr_writereference;
    assign csrrsx_res           =   csr_org | csr_writereference;    
    assign csrrcx_res           =   csr_org & ~csr_writereference;
    
    //mcycle
    always @( posedge clk ) begin
        if( rst ) begin
            mcycle_r <= `DATA_BUS_SIZE'b0;
        end
        else  if( index_mcycle & inst_valid )begin
            mcycle_r <= csr_nxt;
        end
        else begin
            mcycle_r <= mcycle_nxt;
        end
    end

    //misa
    assign misa_r               =   { 2'b10, {`DATA_BUS_SIZE-28{1'b0}}, 26'h0100 };

    //mvendorid
    assign mvendorid_r          =   `DATA_BUS_SIZE'b0;

    //marchid
    assign marchid_r            =   `DATA_BUS_SIZE'b1;

    //mhartid
    assign mhartid_r            =   `DATA_BUS_SIZE'b0;

    //mstatus
    always @( posedge clk ) begin
        if( rst ) begin
            mstatus_r <=  ( `DATA_BUS_SIZE'b11 << 11 );
        end
        else if( index_mstatus & inst_valid ) begin
            mstatus_r <= csr_nxt & `DATA_BUS_SIZE'h88;
        end
        else if( trap_en ) begin
            mstatus_r[7] <= mstatus_r[3];
            mstatus_r[3] <= 1'b0;
        end
        else if( ret_en ) begin
            mstatus_r[7] <= 1'b1;
            mstatus_r[3] <= mstatus_r[7];
        end
        else begin
            mstatus_r <= mstatus_r;
        end
    end 

    //mtvec
    always @( posedge clk ) begin
        if( rst ) begin
            mtvec_r <= `DATA_BUS_SIZE'h0;
        end
        else if( index_mtvec & inst_valid ) begin
            mtvec_r <= csr_nxt & ~64'h3;
        end
        else begin
            mtvec_r <= mtvec_r;
        end
    end

    //mepc
    always @( posedge clk ) begin
        if( rst ) begin
            mepc_r <= `DATA_BUS_SIZE'h0;
        end
        else if( index_mepc & inst_valid ) begin
            mepc_r <= csr_nxt;
        end
        else if( inst_trap ) begin
            mepc_r <= inst_addr;
        end
        else begin
            mepc_r <= mepc_r;
        end
    end    

    //mcause
    always @( posedge clk ) begin
        if( rst ) begin
            mcause_r <= `DATA_BUS_SIZE'h0;
        end
        else if( inst_valid & index_mcause ) begin
            mcause_r <= csr_nxt;
        end
        else if( inst_ecall & inst_valid ) begin
            mcause_r <= `DATA_BUS_SIZE'd11; 
        end
        else if( inst_ebreak & inst_valid ) begin
            mcause_r <= `DATA_BUS_SIZE'd3;
        end
        else if( clint_mtip & inst_valid ) begin
            mcause_r <= ( `DATA_BUS_SIZE'h1<<(`DATA_BUS_SIZE-1) ) + `DATA_BUS_SIZE'h7;
        end
        else begin
            mcause_r <= mcause_r;
        end
    end

    //mip
    always @( posedge clk ) begin
        if( rst ) begin
            mip_r <= `DATA_BUS_SIZE'h0;
        end
        else if( index_mip & inst_valid ) begin
            mip_r <= csr_nxt & `DATA_BUS_SIZE'h80;
        end
        else if( clint_mtip ) begin
            mip_r[7] <= 1'b1;
        end
        else begin
            mip_r <= mip_r;
        end
    end

    //mie
    always @( posedge clk ) begin
        if( rst ) begin
            mie_r <= `DATA_BUS_SIZE'h80;
        end
        else if( index_mie & inst_valid ) begin
            mie_r <= csr_nxt & `DATA_BUS_SIZE'h80;
        end
        else begin
            mie_r <= mie_r;
        end
    end

    //mscratch
    always @( posedge clk ) begin
        if( rst ) begin
            mscratch_r <= `DATA_BUS_SIZE'h0;
        end
        else if( index_mscratch & inst_valid ) begin
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
        else if( index_minstret & inst_valid ) begin
            minstret_r <= csr_nxt;
        end
        else if( inst_valid ) begin
            minstret_r <= minstret_nxt;
        end
        else begin
            minstret_r <= minstret_r;
        end
    end


    //output
    assign csr_trap             =   mstatus_r[4] & ( mie_r[7] & clint_mtip );
    assign csr_nxt_pc           =   inst_ecall? mtvec_r: mepc_r;
    assign csr_read             =    { `DATA_BUS_SIZE { index_mcycle } } & ( mcycle_r )
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
    // assign csr_skip             =   ~( index_mstatus | index_mtvec | index_mepc | index_mepc | index_mcause | index_mip | index_mie | index_mscratch );
    assign mstatus              =   mstatus_r;
    assign mtvec                =   mtvec_r;
    assign mepc                 =   mepc_r;
    assign mcause               =   mcause_r;
    assign mip                  =   mip_r;
    assign mie                  =   mie_r;
    assign mscratch             =   mscratch_r;
    `endif
endmodule
