`include "defines.v"
module ram_top(
    input                       clk,
    
    input   [`INST_ADDR_BUS]    inst_addr,
    input                       inst_en,
    output  [`INST_BUS]         inst,

    // DATA PORT
    input   [`STORE_TYPE_BUS]   store_type,
    input   [`LOAD_TYPE_BUS]    load_type,
    input                       mem_write,
    input                       mem_read,
    input   [`DATA_ADDR_BUS]    data_addr,
    input   [`DATA_BUS]         write_data,
    output  [`DATA_BUS]         read_data
);

    wire [`DATA_BUS] write_mask;

    ram_mem my_ram_mem(
        .clk( clk ),

        .inst_addr( inst_addr ),
        .inst_en( inst_en ),
        .inst( inst ),

        // DATA PORT
        .mem_write( mem_write ),
        .mem_read( mem_read ),
        .write_mask( write_mask ),
        .data_addr( data_addr ),
        .write_data( write_data ),
        .read_data( read_data_pre )
    );

    ram_maskgen my_ram_maskgen(
        .addr_low( data_addr[2:0] ),
        .store_type( store_type ),
        .write_mask( wrire_mask )
    );
    
    ram_signedextend my_ram_signedextend(
        .addr_low( data_addr[2:0] ),
        .load_type( load_type ),
        .read_data( read_data_pre ),
        .signedextend_data( read_data )
    );
endmodule