`include "defines.v"
module csr_top (
    input                           clk,
    input                           rst,

    input                           inst_valid,
    input   [`CSR_INDEX_BUS]        csr_index,
    input   [`DATA_BUS]             rs1_data,
    input   [`DATA_BUS]             imm_csr,
    input   [`CSR_CTRL_BUS]         csr_ctrl,
    input                           csr_src,

    output  [`DATA_BUS]             csr_read
);
    /* index */
    wire                            index_mcycle;

    /* control */  
    wire                            inst_csrrwx;
    wire                            inst_csrrsx;
    wire                            inst_csrrcx;
    wire                            inst_csrinvalid;
    /* reg */
    reg     [`DATA_BUS]             mcycle_r;
    wire    [`DATA_BUS]             csr_nxt;
    wire    [`DATA_BUS]             csr_org;
    wire    [`DATA_BUS]             csr_writereference;
    wire    [`DATA_BUS]             csrrwx_res;
    wire    [`DATA_BUS]             csrrsx_res;
    wire    [`DATA_BUS]             csrrcx_res;


    assign index_mcycle         =   csr_index == `CSR_MCYCLE_INDEX;

    assign inst_csrrwx          =   csr_ctrl[1:0] == 2'b01;
    assign inst_csrrsx          =   csr_ctrl[1:0] == 2'b10;
    assign inst_csrrcx          =   csr_ctrl[1:0] == 2'b11;
    assign inst_csrinvalid      =   ( csr_ctrl[1:0] == 2'b00 ) & ( csr_src == 1'b1 ); 

    assign csr_nxt              =   { `DATA_BUS_SIZE { inst_csrinvalid } } & csr_org 
                                    | { `DATA_BUS_SIZE { inst_csrrwx } } & csrrwx_res
                                    | { `DATA_BUS_SIZE { inst_csrrsx } } & csrrsx_res
                                    | { `DATA_BUS_SIZE { inst_csrrcx } } & csrrcx_res ;  
    
    assign csr_org              =   { `DATA_BUS_SIZE { index_mcycle } } & ( mcycle_r + 1 );
    assign csr_writereference   =   csr_src ? imm_csr: rs1_data;
    assign csrrwx_res           =   csr_writereference;
    assign csrrsx_res           =   csr_org | csr_writereference;    
    assign csrrcx_res           =   csr_org & ~csr_writereference;
    
    assign csr_read             =    { `DATA_BUS_SIZE { index_mcycle } } & ( mcycle_r );

    always @( posedge clk ) begin
        if( rst ) begin
            mcycle_r <= `DATA_BUS_SIZE'b0;
        end
        else  if( index_mcycle & inst_valid )begin
            mcycle_r <= csr_nxt;
        end
        else begin
            mcycle_r <= mcycle_r + 1;
        end
    end

    

endmodule
