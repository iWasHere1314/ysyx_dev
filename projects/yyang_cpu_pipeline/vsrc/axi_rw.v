
`include "defines.v"

// Burst types
`define AXI_BURST_TYPE_FIXED                                2'b00
`define AXI_BURST_TYPE_INCR                                 2'b01
`define AXI_BURST_TYPE_WRAP                                 2'b10
// Access permissions
`define AXI_PROT_UNPRIVILEGED_ACCESS                        3'b000
`define AXI_PROT_PRIVILEGED_ACCESS                          3'b001
`define AXI_PROT_SECURE_ACCESS                              3'b000
`define AXI_PROT_NON_SECURE_ACCESS                          3'b010
`define AXI_PROT_DATA_ACCESS                                3'b000
`define AXI_PROT_INSTRUCTION_ACCESS                         3'b100
// Memory types (AR)
`define AXI_ARCACHE_DEVICE_NON_BUFFERABLE                   4'b0000
`define AXI_ARCACHE_DEVICE_BUFFERABLE                       4'b0001
`define AXI_ARCACHE_NORMAL_NON_CACHEABLE_NON_BUFFERABLE     4'b0010
`define AXI_ARCACHE_NORMAL_NON_CACHEABLE_BUFFERABLE         4'b0011
`define AXI_ARCACHE_WRITE_THROUGH_NO_ALLOCATE               4'b1010
`define AXI_ARCACHE_WRITE_THROUGH_READ_ALLOCATE             4'b1110
`define AXI_ARCACHE_WRITE_THROUGH_WRITE_ALLOCATE            4'b1010
`define AXI_ARCACHE_WRITE_THROUGH_READ_AND_WRITE_ALLOCATE   4'b1110
`define AXI_ARCACHE_WRITE_BACK_NO_ALLOCATE                  4'b1011
`define AXI_ARCACHE_WRITE_BACK_READ_ALLOCATE                4'b1111
`define AXI_ARCACHE_WRITE_BACK_WRITE_ALLOCATE               4'b1011
`define AXI_ARCACHE_WRITE_BACK_READ_AND_WRITE_ALLOCATE      4'b1111
// Memory types (AW)
`define AXI_AWCACHE_DEVICE_NON_BUFFERABLE                   4'b0000
`define AXI_AWCACHE_DEVICE_BUFFERABLE                       4'b0001
`define AXI_AWCACHE_NORMAL_NON_CACHEABLE_NON_BUFFERABLE     4'b0010
`define AXI_AWCACHE_NORMAL_NON_CACHEABLE_BUFFERABLE         4'b0011
`define AXI_AWCACHE_WRITE_THROUGH_NO_ALLOCATE               4'b0110
`define AXI_AWCACHE_WRITE_THROUGH_READ_ALLOCATE             4'b0110
`define AXI_AWCACHE_WRITE_THROUGH_WRITE_ALLOCATE            4'b1110
`define AXI_AWCACHE_WRITE_THROUGH_READ_AND_WRITE_ALLOCATE   4'b1110
`define AXI_AWCACHE_WRITE_BACK_NO_ALLOCATE                  4'b0111
`define AXI_AWCACHE_WRITE_BACK_READ_ALLOCATE                4'b0111
`define AXI_AWCACHE_WRITE_BACK_WRITE_ALLOCATE               4'b1111
`define AXI_AWCACHE_WRITE_BACK_READ_AND_WRITE_ALLOCATE      4'b1111

`define MEM_AXI_SIZE_BYTES_1                                    3'b000
`define MEM_AXI_SIZE_BYTES_2                                    3'b001
`define MEM_AXI_SIZE_BYTES_4                                    3'b010
`define MEM_AXI_SIZE_BYTES_8                                    3'b011
`define MEM_AXI_SIZE_BYTES_16                                   3'b100
`define MEM_AXI_SIZE_BYTES_32                                   3'b101
`define MEM_AXI_SIZE_BYTES_64                                   3'b110
`define MEM_AXI_SIZE_BYTES_128                                  3'b111


module axi_rw # (
    parameter RW_DATA_WIDTH     = 64,
    parameter AXI_DATA_WIDTH    = 64,
    parameter AXI_ADDR_WIDTH    = 64,
    parameter AXI_ID_WIDTH      = 4,
    parameter AXI_USER_WIDTH    = 1
)(
    input                               clock,
    input                               reset,

	input                               rw_valid_i,
	output                              rw_ready_o,
    input                               rw_req_i,
    output [RW_DATA_WIDTH-1:0]          data_read_o,
    input  [RW_DATA_WIDTH-1:0]          data_write_i,
    input  [AXI_DATA_WIDTH-1:0]         rw_addr_i,
    input  [1:0]                        rw_size_i,
    output [1:0]                        rw_resp_o,
    input  [AXI_ID_WIDTH-1:0]           rw_id_i,
    // Advanced eXtensible Interface
    
    //?????????
    input                               axi_aw_ready_i,
    output                              axi_aw_valid_o,
    output [AXI_ADDR_WIDTH-1:0]         axi_aw_addr_o,
    output [2:0]                        axi_aw_prot_o,
    output [AXI_ID_WIDTH-1:0]           axi_aw_id_o,
    output [AXI_USER_WIDTH-1:0]         axi_aw_user_o,
    output [7:0]                        axi_aw_len_o,
    output [2:0]                        axi_aw_size_o,
    output [1:0]                        axi_aw_burst_o,
    output                              axi_aw_lock_o,
    output [3:0]                        axi_aw_cache_o,
    output [3:0]                        axi_aw_qos_o,
    output [3:0]                        axi_aw_region_o,

    //?????????
    input                               axi_w_ready_i,
    output                              axi_w_valid_o,
    output [AXI_DATA_WIDTH-1:0]         axi_w_data_o,
    output [AXI_DATA_WIDTH/8-1:0]       axi_w_strb_o,
    output                              axi_w_last_o,
    output [AXI_USER_WIDTH-1:0]         axi_w_user_o,
    
    //?????????
    output                              axi_b_ready_o,
    input                               axi_b_valid_i,
    input  [1:0]                        axi_b_resp_i,
    input  [AXI_ID_WIDTH-1:0]           axi_b_id_i,
    input  [AXI_USER_WIDTH-1:0]         axi_b_user_i,

    //?????????
    input                               axi_ar_ready_i,
    output                              axi_ar_valid_o,
    output [AXI_ADDR_WIDTH-1:0]         axi_ar_addr_o,
    output [2:0]                        axi_ar_prot_o,
    output [AXI_ID_WIDTH-1:0]           axi_ar_id_o,
    output [AXI_USER_WIDTH-1:0]         axi_ar_user_o,
    output [7:0]                        axi_ar_len_o,
    output [2:0]                        axi_ar_size_o,
    output [1:0]                        axi_ar_burst_o,
    output                              axi_ar_lock_o,
    output [3:0]                        axi_ar_cache_o,
    output [3:0]                        axi_ar_qos_o,
    output [3:0]                        axi_ar_region_o,
    
    //?????????????????????
    output                              axi_r_ready_o,
    input                               axi_r_valid_i,
    input  [1:0]                        axi_r_resp_i,
    input  [AXI_DATA_WIDTH-1:0]         axi_r_data_i,
    input                               axi_r_last_i,
    input  [AXI_ID_WIDTH-1:0]           axi_r_id_i,
    input  [AXI_USER_WIDTH-1:0]         axi_r_user_i
);

    wire to_mem     = rw_addr_i >= 64'h8000_0000;

    wire w_trans    = rw_req_i == `REQ_WRITE;
    wire r_trans    = rw_req_i == `REQ_READ;
    wire w_valid    = rw_valid_i & w_trans;
    wire r_valid    = rw_valid_i & r_trans;

    // handshake
    wire aw_hs      = axi_aw_ready_i & axi_aw_valid_o;
    wire w_hs       = axi_w_ready_i  & axi_w_valid_o;
    wire b_hs       = axi_b_ready_o  & axi_b_valid_i;
    wire ar_hs      = axi_ar_ready_i & axi_ar_valid_o;
    wire r_hs       = axi_r_ready_o  & axi_r_valid_i; 

    wire w_done     = w_hs & axi_w_last_o;// ??????write done????????????????????????
    wire r_done     = r_hs & axi_r_last_i;
    wire trans_done = w_trans ? b_hs : r_done;

    
    // ------------------State Machine------------------
    localparam [1:0] W_STATE_IDLE = 2'b00, W_STATE_ADDR = 2'b01, W_STATE_WRITE = 2'b10, W_STATE_RESP = 2'b11;
    localparam [1:0] R_STATE_IDLE = 2'b00, R_STATE_ADDR = 2'b01, R_STATE_READ  = 2'b10;
    reg rw_ready;
    reg [1:0] w_state, r_state;
    wire w_state_idle = w_state == W_STATE_IDLE, w_state_addr = w_state == W_STATE_ADDR, w_state_write = w_state == W_STATE_WRITE, w_state_resp = w_state == W_STATE_RESP;
    wire r_state_idle = r_state == R_STATE_IDLE, r_state_addr = r_state == R_STATE_ADDR, r_state_read  = r_state == R_STATE_READ;

    // Wirte State Machine
    always @(posedge clock) begin
        if (reset) begin
            w_state <= W_STATE_IDLE;
        end
        else begin
            if ( w_valid & ~rw_ready ) begin// ???????????????mem_finished??????????????????????????????????????????????????????????????????
                case (w_state)
                    W_STATE_IDLE:               w_state <= W_STATE_ADDR;
                    W_STATE_ADDR:  if (aw_hs)   w_state <= W_STATE_WRITE;
                    W_STATE_WRITE: if (w_done)  w_state <= W_STATE_RESP;
                    W_STATE_RESP:  if (b_hs)    w_state <= W_STATE_IDLE; default: w_state <= w_state; 
                endcase
            end
        end
    end

    // Read State Machine
    always @(posedge clock) begin
        if (reset) begin
            r_state <= R_STATE_IDLE;
        end
        else begin
            if ( r_valid & ~rw_ready ) begin// ??????
                case (r_state)// ??????????????????????????????????????????????????????
                    R_STATE_IDLE:               r_state <= R_STATE_ADDR;
                    R_STATE_ADDR: if (ar_hs)    r_state <= R_STATE_READ;
                    R_STATE_READ: if (r_done)   r_state <= R_STATE_IDLE;
                    default: r_state <= r_state;
                endcase
            end
        end
    end


    // ------------------Number of transmission------------------
    reg [7:0] len; // ?????????????????????beat
    wire [7:0] mem_axi_len;
    wire [7:0] axi_len;
    assign axi_len      = to_mem? mem_axi_len: 8'b0;
    wire len_reset      = reset | (w_trans & w_state_idle) | (r_trans & r_state_idle);
    wire len_incr_en    = (len != axi_len) & (w_hs | r_hs);
    always @(posedge clock) begin
        if (len_reset) begin
            len <= 8'b0;
        end
        else if (len_incr_en) begin
            len <= len + 8'b1;
        end
    end
    // ?????????????????????len???1???????????????????????????len?????????????????????????????????????????????

    // ------------------Process Data------------------
    localparam MEM_ALIGNED_WIDTH = $clog2(AXI_DATA_WIDTH / 8);// ??????????????????????????????????????????????????????log2????????????????????????????????????????????????
    localparam MEM_OFFSET_WIDTH  = $clog2(AXI_DATA_WIDTH);// ???????????????????????????????????????????????????????????????????????????????????????????????????
    localparam MEM_AXI_SIZE      = $clog2(AXI_DATA_WIDTH / 8);// ??????size??????
    localparam MEM_MASK_WIDTH    = AXI_DATA_WIDTH * 2; // ?????????2???????????????????????????lane????????????????????????2????????????mem_mask
    localparam MEM_TRANS_LEN     = RW_DATA_WIDTH / AXI_DATA_WIDTH;
    localparam MEM_BLOCK_TRANS   = MEM_TRANS_LEN > 1 ? 1'b1 : 1'b0;// ??????????????????????????????????????????
        // ???????????????????????????????????????


    wire mem_aligned        = MEM_BLOCK_TRANS | rw_addr_i[MEM_ALIGNED_WIDTH-1:0] == 0;// ?????????block??????????????????????????????1??????????????????????????????????????????????????????????????????
    wire per_aligned        = 1'b1;
    wire aligned            = to_mem? mem_aligned: per_aligned;

    wire size_b             = rw_size_i == `SIZE_B;
    wire size_h             = rw_size_i == `SIZE_H;
    wire size_w             = rw_size_i == `SIZE_W;
    wire size_d             = rw_size_i == `SIZE_D;
    wire [3:0] mem_addr_op1     = {{4-MEM_ALIGNED_WIDTH{1'b0}}, rw_addr_i[MEM_ALIGNED_WIDTH-1:0]};
                                // ???????????????????????????????????????
    wire [3:0] mem_addr_op2     = ({4{size_b}} & {4'b0})
                                | ({4{size_h}} & {4'b1})
                                | ({4{size_w}} & {4'b11})
                                | ({4{size_d}} & {4'b111})
                                ;
    wire [3:0] mem_addr_end     = mem_addr_op1 + mem_addr_op2;// ??????????????????????????????

    wire mem_overstep           = mem_addr_end[3:MEM_ALIGNED_WIDTH] != {3-MEM_ALIGNED_WIDTH+1{1'b0}};// ????????????????????????0?????????????????????????????????????????????????????????lane
    wire overstep               = to_mem? mem_overstep: 1'b0;

    assign mem_axi_len      = mem_aligned ? 8'b0/* MEM_TRANS_LEN - 1 */ : {{7{1'b0}}, mem_overstep};// ?????????????????????????????????MEM_TRANS_LEN==1,???????????????????????????????????????
    // assign axi_len          = to_mem? mem_axi_len: per_axi_len;

    wire [2:0] mem_axi_size     = MEM_AXI_SIZE[2:0];
    wire [2:0] per_axi_size     = {1'b0, rw_size_i};
    wire [2:0] axi_size         = to_mem? mem_axi_size: per_axi_size;

    wire [AXI_ADDR_WIDTH-1:0] mem_axi_addr          = {rw_addr_i[AXI_ADDR_WIDTH-1:MEM_ALIGNED_WIDTH], {MEM_ALIGNED_WIDTH{1'b0}}};// ?????????????????????
    wire [MEM_OFFSET_WIDTH-1:0] mem_aligned_offset_l    = {{MEM_OFFSET_WIDTH-MEM_ALIGNED_WIDTH{1'b0}}, {rw_addr_i[MEM_ALIGNED_WIDTH-1:0]}} << 3;// ??????????????????lane??????
    wire [MEM_OFFSET_WIDTH:0]   mem_aligned_offset_h_pre= AXI_DATA_WIDTH - mem_aligned_offset_l;// ??????????????????lane??????
    wire [MEM_OFFSET_WIDTH-1:0] mem_aligned_offset_h    = mem_aligned_offset_h_pre[MEM_OFFSET_WIDTH-1:0];
    wire [MEM_MASK_WIDTH-1:0] mem_mask                  = (({MEM_MASK_WIDTH{size_b}} & {{MEM_MASK_WIDTH-8{1'b0}}, 8'hff})
                                                    | ({MEM_MASK_WIDTH{size_h}} & {{MEM_MASK_WIDTH-16{1'b0}}, 16'hffff})
                                                    | ({MEM_MASK_WIDTH{size_w}} & {{MEM_MASK_WIDTH-32{1'b0}}, 32'hffff_ffff})
                                                    | ({MEM_MASK_WIDTH{size_d}} & {{MEM_MASK_WIDTH-64{1'b0}}, 64'hffff_ffff_ffff_ffff})
                                                    ) << mem_aligned_offset_l;// ???????????????mem_mask??????128???????????????????????????
    wire [AXI_DATA_WIDTH-1:0] per_mask                  = ( ({AXI_DATA_WIDTH{size_b}} & {{AXI_DATA_WIDTH-8{1'b0}}, 8'hff})
                                                    | ({AXI_DATA_WIDTH{size_h}} & {{AXI_DATA_WIDTH-16{1'b0}}, 16'hffff})
                                                    | ({AXI_DATA_WIDTH{size_w}} & {{AXI_DATA_WIDTH-32{1'b0}}, 32'hffff_ffff}) )
                                                      << ( { 3'b0, rw_addr_i[2:0] } << 3 );

    wire [AXI_DATA_WIDTH-1:0] mem_mask_l            = mem_mask[AXI_DATA_WIDTH-1:0];
    wire [AXI_DATA_WIDTH-1:0] mem_mask_h            = mem_mask[MEM_MASK_WIDTH-1:AXI_DATA_WIDTH];// l???h??????????????????
    wire [AXI_DATA_WIDTH-1:0] mask_l                = mem_mask_l;
    wire [AXI_DATA_WIDTH-1:0] mask_h                = mem_mask_h;
    wire [MEM_OFFSET_WIDTH-1:0] aligned_offset_l    = mem_aligned_offset_l;
    wire [MEM_OFFSET_WIDTH-1:0] aligned_offset_h    = mem_aligned_offset_h;
    wire [AXI_ADDR_WIDTH-1:0] axi_addr              = mem_axi_addr;
    wire [AXI_USER_WIDTH-1:0] axi_user              = {AXI_USER_WIDTH{1'b0}};// ???????????????????????????


    /* ?????????????????????cpu?????? */
    wire rw_ready_nxt = trans_done;// ?????????????????????????????????
    wire rw_ready_en  = trans_done | rw_ready;
        // ??????ready???0??????tans????????????trans_done?????????ready??????
        // ?????????master??????????????????????????????valid??????????????????tans_done????????????ready???????????????ready?????????
    always @(posedge clock) begin
        if (reset) begin
            rw_ready <= 1'b0;
        end
        else if (rw_ready_en) begin
            rw_ready <= rw_ready_nxt;
        end
        else begin
            rw_ready <= rw_ready;
        end
    end
    assign rw_ready_o     = rw_ready;
        //??????rw_ready???????????????????????????????????????????????????????????????

    // ???????????????????????????
    reg [1:0] rw_resp;
    wire [1:0] rw_resp_nxt = w_trans ? axi_b_resp_i : axi_r_resp_i;
    wire resp_en = trans_done;
    always @(posedge clock) begin
        if (reset) begin
            rw_resp <= 2'b0;
        end
        else if (resp_en) begin
            rw_resp <= rw_resp_nxt;
        end
    end
    assign rw_resp_o      = rw_resp;


    /* ?????????????????????slave?????? */
    // ------------------Write Transaction------------------
    // aw
    assign axi_aw_valid_o   = w_state_addr;
    assign axi_aw_addr_o    = axi_addr;
    assign axi_aw_prot_o    = `AXI_PROT_UNPRIVILEGED_ACCESS | `AXI_PROT_SECURE_ACCESS | `AXI_PROT_DATA_ACCESS; //????????????
    assign axi_aw_id_o      = rw_id_i;
    assign axi_aw_user_o    = axi_user;
    assign axi_aw_len_o     = axi_len;
    assign axi_aw_size_o    = axi_size;
    assign axi_aw_burst_o   = `AXI_BURST_TYPE_INCR;
    assign axi_aw_lock_o    = 1'b0;
    assign axi_aw_cache_o   = `AXI_AWCACHE_NORMAL_NON_CACHEABLE_NON_BUFFERABLE;
    assign axi_aw_qos_o     = 4'h0;
    assign axi_aw_region_o  = 4'h0;

    //w
    reg [AXI_DATA_WIDTH-1:0] mem_axi_w_data_r;
    reg [AXI_DATA_WIDTH/8-1:0] mem_axi_w_strb_r;
    reg [AXI_DATA_WIDTH-1:0] per_axi_w_data_r;
    reg [AXI_DATA_WIDTH/8-1:0] per_axi_w_strb_r;

    assign axi_w_valid_o    = w_state_write;
    assign axi_w_data_o     = to_mem? mem_axi_w_data_r: per_axi_w_data_r;
    assign axi_w_strb_o     = to_mem? mem_axi_w_strb_r: per_axi_w_strb_r;
    assign axi_w_last_o     = axi_len == len;
    assign axi_w_user_o     = axi_user;

    genvar i;
    generate
        for( i=0; i < MEM_TRANS_LEN; i = i + 1 ) begin: axi_w_for
            always @( posedge clock ) begin
                if( reset ) begin
                    mem_axi_w_data_r <= {AXI_DATA_WIDTH{1'b0}}; mem_axi_w_strb_r <= {AXI_DATA_WIDTH/8{1'b0}};
                end
                else if( ~aligned & overstep ) begin
                    // ??????????????????????????????????????????????????????ready????????????????????????????????????????????????
                    // ??????????????????????????????
                    if( len[0] ) begin
                        mem_axi_w_data_r <= data_write_i & mask_l;
                        mem_axi_w_strb_r <= { mask_l[56],mask_l[48], mask_l[40], mask_l[32], mask_l[24], mask_l[16], mask_l[8], mask_l[0] } ;
                    end
                    else begin
                        mem_axi_w_data_r <= ( data_write_i >> aligned_offset_l )& mask_h;
                        mem_axi_w_strb_r <= { mask_h[56], mask_h[48], mask_h[40], mask_h[32], mask_h[24], mask_h[16], mask_h[8], mask_h[0] } ;
                    end
                end
                else if( len == i )begin
                    mem_axi_w_data_r <= data_write_i[i*AXI_DATA_WIDTH +: AXI_DATA_WIDTH ] & mask_l;
                    mem_axi_w_strb_r <= { mask_l[56], mask_l[48], mask_l[40], mask_l[32], mask_l[24], mask_l[16], mask_l[8], mask_l[0] } ;
                end
            end
        end
    endgenerate

    always @( posedge clock ) begin
        if( reset ) begin
            per_axi_w_data_r <= {AXI_DATA_WIDTH{1'b0}}; per_axi_w_strb_r <= {AXI_DATA_WIDTH/8{1'b0}};
        end
        else begin
            per_axi_w_data_r <= data_write_i & per_mask;
            per_axi_w_strb_r <= { per_mask[56], per_mask[48], per_mask[40], per_mask[32], per_mask[24], per_mask[16], per_mask[8], per_mask[0] } ;
        end
    end
    



    //b

    assign axi_b_ready_o    = w_state_resp;
    

    // ------------------Read Transaction------------------

    // Read address channel signals
    assign axi_ar_valid_o   = r_state_addr;// ???????????????????????????????????????????????????
    assign axi_ar_addr_o    = axi_addr;
    assign axi_ar_prot_o    = `AXI_PROT_UNPRIVILEGED_ACCESS | `AXI_PROT_SECURE_ACCESS | `AXI_PROT_DATA_ACCESS; //????????????
    assign axi_ar_id_o      = rw_id_i;
    assign axi_ar_user_o    = axi_user;
    assign axi_ar_len_o     = axi_len;
    assign axi_ar_size_o    = axi_size;
    assign axi_ar_burst_o   = `AXI_BURST_TYPE_INCR;
    assign axi_ar_lock_o    = 1'b0;
    assign axi_ar_cache_o   = `AXI_ARCACHE_NORMAL_NON_CACHEABLE_NON_BUFFERABLE;
    assign axi_ar_qos_o     = 4'h0;
    assign axi_ar_region_o  = 4'h0;

    // Read data channel signals
    assign axi_r_ready_o    = r_state_read;// ?????????

    wire [AXI_DATA_WIDTH-1:0] axi_r_data_l  = (axi_r_data_i & mask_l) >> aligned_offset_l;
    wire [AXI_DATA_WIDTH-1:0] axi_r_data_h  = (axi_r_data_i & mask_h) << aligned_offset_h;// ??????????????? ?????????????????????????????????????????????????????????  

    reg [RW_DATA_WIDTH-1:0] mem_read_r;
    reg [RW_DATA_WIDTH-1:0] per_read_r;
    assign data_read_o = to_mem? mem_read_r: per_read_r;

    generate
        for ( i = 0; i < MEM_TRANS_LEN; i = i + 1) begin: mem_read_for // verilog????????????+=?????????????????????sv???
            // MEM_TRANS_LEN????????????????????????RW???????????????????????????????????????
            // 
            always @(posedge clock) begin
                if (reset) begin
                    mem_read_r[i*AXI_DATA_WIDTH+:AXI_DATA_WIDTH] <= {AXI_DATA_WIDTH{1'b0}};
                end
                    //????????????????????????????????????????????????MEM_TRANS_LEN
                else if ( r_hs ) begin // ????????????hs??????????????????????????????
                    if (~aligned & overstep) begin
                        if (len[0]) begin// ???????????????????????????
                            mem_read_r[AXI_DATA_WIDTH-1:0] <= mem_read_r[AXI_DATA_WIDTH-1:0] | axi_r_data_h;
                        end
                        else begin// ?????????????????????
                            mem_read_r[AXI_DATA_WIDTH-1:0] <= mem_read_r;
                        end
                    end
                    // ???????????????????????????????????????????????????????????????
                    // ???????????????????????????????????????
                    else if (len == i) begin
                        mem_read_r[i*AXI_DATA_WIDTH+:AXI_DATA_WIDTH] <= axi_r_data_l;
                    end
                end
            end
        end
    endgenerate

    always @(posedge clock) begin
        if (reset) begin
            per_read_r <= {AXI_DATA_WIDTH{1'b0}};
        end
        else begin
            per_read_r <= ( axi_r_data_i & per_mask ) >> ( { 3'b0, rw_addr_i[2:0] } << 3 );
        end
    end

endmodule
