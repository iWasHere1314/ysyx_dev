`include "defines.v"
module mem_top(
    input                       clk,
    input                       rst,

    input   [`STORE_TYPE_BUS]   store_type,
    input   [`LOAD_TYPE_BUS]    load_type,
    input                       mem_write,
    input                       mem_read,
    input   [`DATA_ADDR_BUS]    data_addr,
    input   [`DATA_BUS]         write_data,
    output  [`DATA_BUS]         read_data,
    input                       inst_valid,

    output                      mem_valid,
    input                       mem_ready,
    input   [`DATA_BUS]         mem_data_read,
    output  [`DATA_BUS]         mem_data_write,
    output  [`DATA_ADDR_BUS]    mem_addr,
    output  [1:0]               mem_size,
    input   [1:0]               mem_resp,
    output                      mem_req
);
    
    /* write */
    wire                        store_eff;
    wire                        store_sb;
    wire                        store_sh;
    wire                        store_sw;
    wire                        store_sd;

    /* read */
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

    /* interface */

    reg                         mem_finished;
    reg     [`DATA_BUS]         read_data_r;
    wire                        handshake_done;

    /* assignment */
    assign store_eff                =   store_type[2] == 1'b1;
    assign store_sb                 =   store_eff & ( store_type[1:0] == 2'b00 );
    assign store_sh                 =   store_eff & ( store_type[1:0] == 2'b01 );
    assign store_sw                 =   store_eff & ( store_type[1:0] == 2'b10 );
    assign store_sd                 =   store_eff & ( store_type[1:0] == 2'b11 );


    assign load_lbx                 =   load_type[1:0] == 2'b01;
    assign load_lhx                 =   load_type[1:0] == 2'b10;
    assign load_lwx                 =   load_type[1:0] == 2'b11;
    assign load_ld                  =   load_type[2:0] == 3'b100;
    assign load_signed              =   ( load_type[2] == 1'b0 ) && ( load_type[1:0] != 2'b0 ); 

    assign signed_bit               =  load_signed & 
                                        ( 1'b0 | load_lbx & read_data_r[07]
                                               | load_lhx & read_data_r[15]
                                               | load_lwx & read_data_r[31]
                                               | load_ld  & read_data_r[63] 
                                        );

    assign mask_lbx                 =   64'hff;
    assign mask_lhx                 =   64'hffff;
    assign mask_lwx                 =   64'hffff_ffff;
    assign mask_ld                  =   ~64'h0;
    assign mask                     =   64'h0 | ( { 64 { load_lbx } } & mask_lbx )
                                              | ( { 64 { load_lhx } } & mask_lhx )
                                              | ( { 64 { load_lwx } } & mask_lwx )
                                              | ( { 64 { load_ld  } } & mask_ld  );
    assign read_data                =   load_signed? 
                                        ( ( read_data_r  ) | ( { 64 { signed_bit } } & ~mask ) )
                                        : read_data_r;


    assign mem_valid                =   ( mem_write | mem_read ) & ~mem_finished;
    assign mem_data_write           =   write_data <<( { 3'b0, data_addr[2:0] } << 3 );
    assign mem_addr                 =   data_addr;
    assign mem_size                 =     { 2 { store_sb | load_lbx } } & `SIZE_B 
                                        | { 2 { store_sh | load_lhx } } & `SIZE_H
                                        | { 2 { store_sw | load_lwx } } & `SIZE_W
                                        | { 2 { store_sd | load_ld  } } & `SIZE_D ;
    assign mem_req                  =   ( mem_read & `REQ_READ ) | ( mem_write & `REQ_WRITE );  
    assign handshake_done           =   mem_valid & mem_ready;

    always @( posedge clk ) begin
        if( rst ) begin
            read_data_r <= `ZERO_DWORD;
        end
        else if( handshake_done & mem_read ) begin
            read_data_r <= mem_data_read;
        end
        else begin
            read_data_r <= read_data_r;
        end
    end

    always @( posedge clk ) begin
        if( rst | inst_valid ) begin
            mem_finished <= 1'b0;
        end
        else if( handshake_done ) begin
            mem_finished <= 1'b1;
        end
        else begin
            mem_finished <= mem_finished;
        end
    end
endmodule