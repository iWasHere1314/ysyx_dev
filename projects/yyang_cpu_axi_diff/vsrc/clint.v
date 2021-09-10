`include "defines.v"
module clint (
    input                       clk,
    input                       rst,

    output                      clint_mtip,
    output                      clint_update,
    input                       clint_valid,
    input   [`DATA_BUS]         clint_data_write,
    input   [`DATA_ADDR_BUS]    clint_addr,
    input   [1:0]               clint_size,
    input                       clint_req,

    output                      clint_ready,
    output  [`DATA_BUS]         clint_data_read,
    output  [1:0]               clint_resp
);

    reg     [`DATA_BUS]         mtime_r;
    reg     [`DATA_BUS]         mtimecmp_r;
    reg                         clint_update_r;
    wire                        clint_read;
    wire                        clint_write;
    wire                        mtime_en;
    wire                        mtimecmp_en;

    assign clint_read           =   clint_req == `REQ_READ;
    assign clint_write          =   clint_req == `REQ_WRITE;
    assign mtime_en             =   clint_valid & ( clint_addr == `MTIME_ADDR );
    assign mtimecmp_en          =   clint_valid & ( clint_addr == `MTIMECMP_ADDR );

    always @( posedge clk ) begin
        if( rst ) begin
            mtime_r <= `DATA_BUS_SIZE'b0;
        end
        else if( mtime_en & clint_write ) begin
            mtime_r <= clint_data_write;
        end
        else begin
            mtime_r <= mtime_r + `DATA_BUS_SIZE'b1;
        end
    end

    always @( posedge clk ) begin
        if( rst ) begin
            mtimecmp_r <= `DATA_BUS_SIZE'b0;
        end
        else if( mtimecmp_en & clint_write ) begin
            mtimecmp_r <= clint_data_write;
        end
        else begin
            mtimecmp_r <= mtimecmp_r;
        end
    end

    always @( posedge clk ) begin
        if( rst | clint_update_r ) begin
            clint_update_r <= 1'b0;
        end    
        else if( clint_write ) begin
            clint_update_r <= 1'b1;
        end
        else begin
            clint_update_r <= clint_update_r;
        end
    end

    assign clint_ready          =   1'b1;
    assign clint_data_read      =   ( { `DATA_BUS_SIZE { mtime_en & clint_read } } & mtime_r ) 
                                    | ( { `DATA_BUS_SIZE { mtimecmp_en & clint_read } } & mtimecmp_r );
    assign clint_resp           =   2'b0;

    assign clint_mtip           =   mtime_r >= mtimecmp_r;
    assign clint_update         =   clint_update_r;
endmodule