`include "defines.v"
module ram_signedextend (
    input   [`ADDR_LOW_BUS]     addr_low,
    input   [`LOAD_TYPE_BUS]    load_type,
    input   [`DATA_BUS]         read_data,
    output  [`DATA_BUS]         signedextend_data
);
    wire                        load_lbx;
    wire                        load_lhx;
    wire                        load_lwx;
    wire                        load_ld;
    wire                        load_signed;

    wire                        signed_bit;

    wire    [`DATA_BUS]         mask_lbx;
    wire    [`DATA_BUS]         mask_lhx;
    wire    [`DATA_BUS]         mask_lwx;
    wire    [`DATA_BUS]         mask_ld;
    wire    [`DATA_BUS]         mask;
    wire    [`DATA_BUS]         signedextend_data_pre;

    assign load_lbx                 =   load_type[1:0] == 2'b01;
    assign load_lhx                 =   load_type[1:0] == 2'b10;
    assign load_lwx                 =   load_type[1:0] == 2'b11;
    assign load_ld                  =   load_type[2:0] == 3'b100;
    assign load_signed              =   ~ ( ( load_type[2] == 1'b1 ) & ~load_ld );

    assign signed_bit               =  load_signed & 
                                        ( 1'b0 | load_lbx & signedextend_data_pre[07]
                                               | load_lhx & signedextend_data_pre[15]
                                               | load_lwx & signedextend_data_pre[31]
                                               | load_ld  & signedextend_data_pre[63] 
                                        );
    assign mask_lbx                 =   64'hff;
    assign mask_lhx                 =   64'hffff;
    assign mask_lwx                 =   64'hffff_ffff;
    assign mask_ld                  =   ~64'h0;
    assign mask                     =   64'h0 | ( { 64 { load_lbx } } & mask_lbx )
                                              | ( { 64 { load_lhx } } & mask_lhx )
                                              | ( { 64 { load_lwx } } & mask_lwx )
                                              | ( { 64 { load_ld  } } & mask_ld  );
    assign signedextend_data_pre    =   read_data >> ( addr_low << 2'd3 );
    
    assign signedextend_data        =   load_signed? 
                                        ( ( signedextend_data_pre & mask ) | ( { 64 { signed_bit } } & ~mask ) )
                                        : signedextend_data_pre;
endmodule