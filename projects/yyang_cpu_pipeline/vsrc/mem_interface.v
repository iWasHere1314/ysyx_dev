`include "defines.v"
module mem_interface(
    input                       clk,
    input                       rst,

    input                       mem_interface_intp_en_i,
    output                      mem_interface_access_ok_o,

    /* cpu side */
    input                       mem_interface_inst_valid_i,
    input   [`STORE_TYPE_BUS]   mem_interface_store_type_i,
    input   [`LOAD_TYPE_BUS]    mem_interface_load_type_i,
    input                       mem_interface_mem_write_i,
    input                       mem_interface_mem_read_i,
    input   [`DATA_ADDR_BUS]    mem_interface_data_addr_i,
    input   [`DATA_BUS]         mem_interface_write_data_i,
    output  [`DATA_BUS]         mem_interface_read_data_o,

    /* access side */
    output                      mem_interface_valid_o,
    input                       mem_interface_ready_i,
    input   [`DATA_BUS]         mem_interface_data_read_i,
    output  [`DATA_BUS]         mem_interface_data_write_o,
    output  [`DATA_ADDR_BUS]    mem_interface_addr_o,
    output  [1:0]               mem_interface_size_o,
    input   [1:0]               mem_interface_resp_i,
    output                      mem_interface_req_o
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
    assign store_eff                    =   mem_interface_store_type_i[2] == 1'b1;
    assign store_sb                     =   store_eff & ( mem_interface_store_type_i[1:0] == 2'b00 );
    assign store_sh                     =   store_eff & ( mem_interface_store_type_i[1:0] == 2'b01 );
    assign store_sw                     =   store_eff & ( mem_interface_store_type_i[1:0] == 2'b10 );
    assign store_sd                     =   store_eff & ( mem_interface_store_type_i[1:0] == 2'b11 );


    assign load_lbx                     =   mem_interface_load_type_i[1:0] == 2'b01;
    assign load_lhx                     =   mem_interface_load_type_i[1:0] == 2'b10;
    assign load_lwx                     =   mem_interface_load_type_i[1:0] == 2'b11;
    assign load_ld                      =   mem_interface_load_type_i[2:0] == 3'b100;
    assign load_signed                  =   ( mem_interface_load_type_i[2] == 1'b0 ) && ( mem_interface_load_type_i[1:0] != 2'b0 ); 

    assign signed_bit                   =  load_signed & 
                                            ( | load_lbx & read_data_r[07]
                                              | load_lhx & read_data_r[15]
                                              | load_lwx & read_data_r[31]
                                              | load_ld  & read_data_r[63] 
                                            );

    assign mask_lbx                     =   64'hff;
    assign mask_lhx                     =   64'hffff;
    assign mask_lwx                     =   64'hffff_ffff;
    assign mask_ld                      =   ~64'h0;
    assign mask                         =       ( { 64 { load_lbx } } & mask_lbx )
                                              | ( { 64 { load_lhx } } & mask_lhx )
                                              | ( { 64 { load_lwx } } & mask_lwx )
                                              | ( { 64 { load_ld  } } & mask_ld  );
    assign mem_interface_read_data_o    =   load_signed? 
                                         ( ( read_data_r  ) | ( { 64 { signed_bit } } & ~mask ) )
                                         : read_data_r;


    assign mem_interface_valid_o        =   ( mem_interface_mem_write_i | mem_interface_mem_read_i ) & ~mem_finished & ~mem_interface_intp_en_i;
    assign mem_interface_data_write_o   =   mem_interface_write_data_i <<( { 3'b0, mem_interface_data_addr_i[2:0] } << 3 );
    assign mem_interface_addr_o         =   mem_interface_data_addr_i;
    assign mem_interface_size_o         =     { 2 { store_sb | load_lbx } } & `SIZE_B 
                                            | { 2 { store_sh | load_lhx } } & `SIZE_H
                                            | { 2 { store_sw | load_lwx } } & `SIZE_W
                                            | { 2 { store_sd | load_ld  } } & `SIZE_D ;
    assign mem_interface_req_o          =   ( mem_interface_mem_read_i & `REQ_READ ) | ( mem_interface_mem_write_i & `REQ_WRITE );  
    assign handshake_done               =   mem_interface_valid_o & mem_interface_ready_i;
    assign mem_interface_access_ok_o    =   mem_finished | mem_interface_intp_en_i;

    always @( posedge clk ) begin
        if( rst ) begin
            read_data_r <= `ZERO_DWORD;
        end
        else if( handshake_done & mem_interface_mem_read_i ) begin
            read_data_r <= mem_interface_data_read_i;
        end
        else begin
            read_data_r <= read_data_r;
        end
    end

    always @( posedge clk ) begin
        if( rst | mem_interface_inst_valid_i ) begin
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