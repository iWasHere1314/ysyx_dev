`include "defines.v"
module mem_clint(
    input                       clk,
    input                       rst,

    output                      mem_clint_clint_mtip_o,
    output                      mem_clint_clint_update_o,
    input                       mem_clint_clint_valid_i,
    input   [`DATA_BUS]         mem_clint_clint_data_write_i,
    input   [`DATA_ADDR_BUS]    mem_clint_clint_addr_i,
    input   [1:0]               mem_clint_clint_size_i,
    input                       mem_clint_clint_req_i,

    output                      mem_clint_clint_ready_o,
    output  [`DATA_BUS]         mem_clint_clint_data_read_o,
    output  [1:0]               mem_clint_clint_resp_o
);

    reg     [`DATA_BUS]         mtime_r;
    reg     [`DATA_BUS]         mtimecmp_r;
    reg                         clint_update_r;
    wire                        clint_read;
    wire                        clint_write;
    wire                        mtime_en;
    wire                        mtimecmp_en;

    assign clint_read           =   mem_clint_clint_req_i == `REQ_READ;
    assign clint_write          =   mem_clint_clint_req_i == `REQ_WRITE;
    assign mtime_en             =   mem_clint_clint_valid_i & ( mem_clint_clint_addr_i == `MTIME_ADDR );
    assign mtimecmp_en          =   mem_clint_clint_valid_i & ( mem_clint_clint_addr_i == `MTIMECMP_ADDR );

    always @( posedge clk ) begin
        if( rst ) begin
            mtime_r <= `DATA_BUS_SIZE'b0;
        end
        else if( mtime_en & clint_write ) begin
            mtime_r <= mem_clint_clint_data_write_i;
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
            mtimecmp_r <= mem_clint_clint_data_write_i;
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

    assign mem_clint_clint_ready_o          =   1'b1;
    assign mem_clint_clint_data_read_o      =   ( { `DATA_BUS_SIZE { mtime_en & clint_read } } & mtime_r ) 
                                                | ( { `DATA_BUS_SIZE { mtimecmp_en & clint_read } } & mtimecmp_r );
    assign mem_clint_clint_resp_o           =   2'b0;

    assign mem_clint_clint_mtip_o           =   mtime_r >= mtimecmp_r;
    assign mem_clint_clint_update_o         =   clint_update_r;
`ifdef DEFINE_DIFFTEST
    always @( posedge clk ) begin
        if( mtime_en & clint_write  ) begin
            $write("write mtime: size:%h, data%h\n", mem_clint_clint_size_i, mem_clint_clint_data_write_i );
        end
        if( mtimecmp_en & clint_write ) begin
            $write("write mtimecmp: size:%h, data%h\n", mem_clint_clint_size_i, mem_clint_clint_data_write_i );
        end
    end
`endif 
endmodule