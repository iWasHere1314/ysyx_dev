`include "defines.v"
module ram_maskgen (
    input   [`ADDR_LOW_BUS]     addr_low,
    input   [`STORE_TYPE_BUS]   store_type,
    input   [`DATA_BUS]         rs2_data,
    output  [`DATA_BUS]         write_data,
    output  [`DATA_BUS]         write_mask
);
    wire                        store_eff;
    wire                        store_sb;
    wire                        store_sh;
    wire                        store_sw;
    wire                        store_sd;
    wire    [`DATA_BUS]         orgmask_sb;
    wire    [`DATA_BUS]         orgmask_sh;
    wire    [`DATA_BUS]         orgmask_sw;
    wire    [`DATA_BUS]         orgmask_sd;
    wire    [`DATA_BUS]         write_mask_pre;
    wire    [`IMM_SHIFT_BUS]    maskgen_shiftnum;

    assign store_eff        =   store_type[2] == 1'b1;
    assign store_sb         =   store_eff & ( store_type[1:0] == 2'b00 );
    assign store_sh         =   store_eff & ( store_type[1:0] == 2'b01 );
    assign store_sw         =   store_eff & ( store_type[1:0] == 2'b10 );
    assign store_sd         =   store_eff & ( store_type[1:0] == 2'b11 );

    assign orgmask_sb       =   64'hff;
    assign orgmask_sh       =   64'hffff;
    assign orgmask_sw       =   64'hffff_ffff;
    assign orgmask_sd       =   ~64'h0;
    
    assign write_mask_pre   =   64'h0 | ( { 64 { store_sb } } & orgmask_sb )
                                      | ( { 64 { store_sh } } & orgmask_sh )
                                      | ( { 64 { store_sw } } & orgmask_sw )
                                      | ( { 64 { store_sd } } & orgmask_sd );   
    assign write_mask       =   write_mask_pre << maskgen_shiftnum;
    assign write_data       =   rs2_data << maskgen_shiftnum;
    
    assign maskgen_shiftnum =   { 3'b000, addr_low } << 2'd3;

endmodule