
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

`define AXI_SIZE_BYTES_1                                    3'b000
`define AXI_SIZE_BYTES_2                                    3'b001
`define AXI_SIZE_BYTES_4                                    3'b010
`define AXI_SIZE_BYTES_8                                    3'b011
`define AXI_SIZE_BYTES_16                                   3'b100
`define AXI_SIZE_BYTES_32                                   3'b101
`define AXI_SIZE_BYTES_64                                   3'b110
`define AXI_SIZE_BYTES_128                                  3'b111


module axi_rw # (
    parameter RW_DATA_WIDTH     = 64,
    parameter RW_ADDR_WIDTH     = 64,
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
    output reg [RW_DATA_WIDTH:0]        data_read_o,
    input  [RW_DATA_WIDTH:0]            data_write_i,
    input  [AXI_DATA_WIDTH:0]           rw_addr_i,
    input  [1:0]                        rw_size_i,
    output [1:0]                        rw_resp_o,
    input  [AXI_ID_WIDTH-1:0]           rw_id_i,
    // Advanced eXtensible Interface
    
    //写地址
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

    //写数据
    input                               axi_w_ready_i,
    output                              axi_w_valid_o,
    output [AXI_DATA_WIDTH-1:0]         axi_w_data_o,
    output [AXI_DATA_WIDTH/8-1:0]       axi_w_strb_o,
    output                              axi_w_last_o,
    output [AXI_USER_WIDTH-1:0]         axi_w_user_o,
    
    //写返回
    output                              axi_b_ready_o,
    input                               axi_b_valid_i,
    input  [1:0]                        axi_b_resp_i,
    input  [AXI_ID_WIDTH-1:0]           axi_b_id_i,
    input  [AXI_USER_WIDTH-1:0]         axi_b_user_i,

    //读地址
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
    
    //读数据（返回）
    output                              axi_r_ready_o,
    input                               axi_r_valid_i,
    input  [1:0]                        axi_r_resp_i,
    input  [AXI_DATA_WIDTH-1:0]         axi_r_data_i,
    input                               axi_r_last_i,
    input  [AXI_ID_WIDTH-1:0]           axi_r_id_i,
    input  [AXI_USER_WIDTH-1:0]         axi_r_user_i
);


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

    wire w_done     = w_hs & axi_w_last_o;// 这个write done只是用于状态转换
    wire r_done     = r_hs & axi_r_last_i;
    wire trans_done = w_trans ? b_hs : r_done;

    
    // ------------------State Machine------------------
    parameter [1:0] W_STATE_IDLE = 2'b00, W_STATE_ADDR = 2'b01, W_STATE_WRITE = 2'b10, W_STATE_RESP = 2'b11;
    parameter [1:0] R_STATE_IDLE = 2'b00, R_STATE_ADDR = 2'b01, R_STATE_READ  = 2'b10;

    reg [1:0] w_state, r_state;
    wire w_state_idle = w_state == W_STATE_IDLE, w_state_addr = w_state == W_STATE_ADDR, w_state_write = w_state == W_STATE_WRITE, w_state_resp = w_state == W_STATE_RESP;
    wire r_state_idle = r_state == R_STATE_IDLE, r_state_addr = r_state == R_STATE_ADDR, r_state_read  = r_state == R_STATE_READ;

    // Wirte State Machine
    always @(posedge clock) begin
        if (reset) begin
            w_state <= W_STATE_IDLE;
        end
        else begin
            if ( w_valid & ~rw_ready ) begin
                case (w_state)
                    W_STATE_IDLE:               w_state <= W_STATE_ADDR;
                    W_STATE_ADDR:  if (aw_hs)   w_state <= W_STATE_WRITE;
                    W_STATE_WRITE: if (w_done)  w_state <= W_STATE_RESP;
                    W_STATE_RESP:  if (b_hs)    w_state <= W_STATE_IDLE;
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
            if (r_valid & ~rw_ready ) begin
                case (r_state)
                    R_STATE_IDLE:               r_state <= R_STATE_ADDR;
                    R_STATE_ADDR: if (ar_hs)    r_state <= R_STATE_READ;
                    R_STATE_READ: if (r_done)   r_state <= R_STATE_IDLE;
                    default:;
                endcase
            end
        end
    end


    // ------------------Number of transmission------------------
    reg [7:0] len; // 正在写的是第几beat
    wire len_reset      = reset | (w_trans & w_state_idle) | (r_trans & r_state_idle);
    wire len_incr_en    = (len != axi_len) & (w_hs | r_hs);
    always @(posedge clock) begin
        if (len_reset) begin
            len <= 0;
        end
        else if (len_incr_en) begin
            len <= len + 1;
        end
    end
    // 此处实现仅支持len为1的读，之所以要设置len时因为单非对齐时，会要求读两次

    // ------------------Process Data------------------
    parameter ALIGNED_WIDTH = $clog2(AXI_DATA_WIDTH / 8);// 首先计算总线一次传输的字节数，字节数log2就知道对齐的是对应地址中的哪几位
    parameter OFFSET_WIDTH  = $clog2(AXI_DATA_WIDTH);// 偏移量，也就是非对齐访问的数据在对齐访问返回的信息中所在位置的偏移
    parameter AXI_SIZE      = $clog2(AXI_DATA_WIDTH / 8);// 用于size信号
    parameter MASK_WIDTH    = AXI_DATA_WIDTH * 2; // 为啥乘2？因为最多跨越两个lane（非对齐时），乘2方便形成mask
    parameter TRANS_LEN     = RW_DATA_WIDTH / AXI_DATA_WIDTH;
    parameter BLOCK_TRANS   = TRANS_LEN > 1 ? 1'b1 : 1'b0;// 这是大于，不是右移，呆比！！
        // 同一事物不允许插入其他事物

    wire aligned            = BLOCK_TRANS | rw_addr_i[ALIGNED_WIDTH-1:0] == 0;// 就默认block（需要传输的次数大于1）就对齐把，具体原因未知，时间有限来不及看了
    wire size_b             = rw_size_i == `SIZE_B;
    wire size_h             = rw_size_i == `SIZE_H;
    wire size_w             = rw_size_i == `SIZE_W;
    wire size_d             = rw_size_i == `SIZE_D;
    wire [3:0] addr_op1     = {{4-ALIGNED_WIDTH{1'b0}}, rw_addr_i[ALIGNED_WIDTH-1:0]};
                                // 高位补零，低位为地址对齐位
    wire [3:0] addr_op2     = ({4{size_b}} & {4'b0})
                                | ({4{size_h}} & {4'b1})
                                | ({4{size_w}} & {4'b11})
                                | ({4{size_d}} & {4'b111})
                                ;
    wire [3:0] addr_end     = addr_op1 + addr_op2;// 结束的那个字节的地址
    wire overstep           = addr_end[3:ALIGNED_WIDTH] != 0;// 最高位未计算前为0，计算之后，出现了进位，说明跨越了一个lane

    wire [7:0] axi_len      = aligned ? TRANS_LEN - 1 : {{7{1'b0}}, overstep};// 根据上文，非对齐一定有TRANS_LEN==1,非对齐且越界，则一定要两次
    wire [2:0] axi_size     = AXI_SIZE[2:0];
    
    wire [AXI_ADDR_WIDTH-1:0] axi_addr          = {rw_addr_i[AXI_ADDR_WIDTH-1:ALIGNED_WIDTH], {ALIGNED_WIDTH{1'b0}}};// 转化为对齐访问
    wire [OFFSET_WIDTH-1:0] aligned_offset_l    = {{OFFSET_WIDTH-ALIGNED_WIDTH{1'b0}}, {rw_addr_i[ALIGNED_WIDTH-1:0]}} << 3;// 非对齐低地址lane偏移
    wire [OFFSET_WIDTH-1:0] aligned_offset_h    = AXI_DATA_WIDTH - aligned_offset_l;// 非对齐高地址lane偏移
    wire [MASK_WIDTH-1:0] mask                  = (({MASK_WIDTH{size_b}} & {{MASK_WIDTH-8{1'b0}}, 8'hff})
                                                    | ({MASK_WIDTH{size_h}} & {{MASK_WIDTH-16{1'b0}}, 16'hffff})
                                                    | ({MASK_WIDTH{size_w}} & {{MASK_WIDTH-32{1'b0}}, 32'hffffffff})
                                                    | ({MASK_WIDTH{size_d}} & {{MASK_WIDTH-64{1'b0}}, 64'hffffffff_ffffffff})
                                                    ) << aligned_offset_l;// 对应的各种mask，用128位方便移位吧。。。
    wire [AXI_DATA_WIDTH-1:0] mask_l            = mask[AXI_DATA_WIDTH-1:0];
    wire [AXI_DATA_WIDTH-1:0] mask_h            = mask[MASK_WIDTH-1:AXI_DATA_WIDTH];// l，h对应关系同理

    wire [AXI_USER_WIDTH-1:0] axi_user          = {AXI_USER_WIDTH{1'b0}};// 用户自定义，不使用


    /* 这一部分是针对cpu端的 */
    reg rw_ready;
    wire rw_ready_nxt = trans_done;// 对的，因为不会同时读写
    wire rw_ready_en      = trans_done | rw_ready;
        // 最初ready为0，单tans完成后，trans_done有效，ready有效
        // 之后，master在收到信号之后会关闭valid，握手结束，tans_done无效，而ready还有效，则ready会清零
    always @(posedge clock) begin
        if (reset) begin
            rw_ready <= 0;
        end
        else if (rw_ready_en) begin
            rw_ready <= rw_ready_nxt;
        end
        else begin
            rw_ready <= rw_ready;
        end
    end
    assign rw_ready_o     = rw_ready;
        //因为rw_ready会迟一个周期，所以返回的读数据并不会有问题

    // 直接将信息返回即可
    reg [1:0] rw_resp;
    wire rw_resp_nxt = w_trans ? axi_b_resp_i : axi_r_resp_i;
    wire resp_en = trans_done;
    always @(posedge clock) begin
        if (reset) begin
            rw_resp <= 0;
        end
        else if (resp_en) begin
            rw_resp <= rw_resp_nxt;
        end
    end
    assign rw_resp_o      = rw_resp;


    /* 这一部分是针对slave端的 */
    // ------------------Write Transaction------------------
    // aw
    assign axi_aw_valid_o   = w_state_addr;
    assign axi_aw_addr_o    = axi_addr;
    assign axi_aw_prot_o    = `AXI_PROT_UNPRIVILEGED_ACCESS | `AXI_PROT_SECURE_ACCESS | `AXI_PROT_DATA_ACCESS; //不做保护
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
    reg [AXI_ADDR_WIDTH-1:0] axi_w_data_r, axi_w_strb_r;
    
    assign axi_w_valid_o    = w_state_write;
    assign axi_w_data_o     = axi_w_data_r;
    assign axi_w_strb_o     = axi_w_strb_r;
    assign axi_w_last_o     = axi_len == len;
    assign axi_w_user_o     = axi_user;

    generate
        for( genvar i=0; i < TRANS_LEN; i = i + 1 ) begin
            always @( posedge clock ) begin
                if( reset ) begin
                    axi_w_data_r <= 0;
                end
                else if( ~aligned & overstep ) begin
                    // 这种写法的唯一保障在于接收方接收到后ready立马置低，即写至少需要额外一周期
                    // 写需要一周期，也合理
                    if( len[0] ) begin
                        axi_w_data_r <= data_write_i & mask_l;
                        axi_w_strb_r <= mask_l;
                    end
                    else begin
                        axi_w_data_r <= ( data_write_i >> aligned_offset_l )& mask_h;
                        axi_w_strb_r <= mask_h;
                    end
                end
                else if( len == i )begin
                    axi_w_data_r <= data_write_i[i*AXI_DATA_WIDTH +: AXI_DATA_WIDTH ] & mask_l;
                    axi_w_strb_r <= mask_l;
                end
            end
        end
    endgenerate
    
    



    //b

    assign axi_b_ready_o    = w_state_resp;
    

    // ------------------Read Transaction------------------

    // Read address channel signals
    assign axi_ar_valid_o   = r_state_addr;// 当目前在输出地址时，那就写地址允许
    assign axi_ar_addr_o    = axi_addr;
    assign axi_ar_prot_o    = `AXI_PROT_UNPRIVILEGED_ACCESS | `AXI_PROT_SECURE_ACCESS | `AXI_PROT_DATA_ACCESS; //不做保护
    assign axi_ar_id_o      = rw_id_i;
    assign axi_ar_user_o    = axi_user;
    assign axi_ar_len_o     = axi_len;
    assign axi_ar_size_o    = axi_size;
    assign axi_ar_burst_o   = `AXI_BURST_TYPE_INCR;
    assign axi_ar_lock_o    = 1'b0;
    assign axi_ar_cache_o   = `AXI_ARCACHE_NORMAL_NON_CACHEABLE_NON_BUFFERABLE;
    assign axi_ar_qos_o     = 4'h0;

    // Read data channel signals
    assign axi_r_ready_o    = r_state_read;// 确实！

    wire [AXI_DATA_WIDTH-1:0] axi_r_data_l  = (axi_r_data_i & mask_l) >> aligned_offset_l;
    wire [AXI_DATA_WIDTH-1:0] axi_r_data_h  = (axi_r_data_i & mask_h) << aligned_offset_h;// 分别移动， 使得两者可以相或就可以直接得到最终数据  

    generate
        for (genvar i = 0; i < TRANS_LEN; i = i + 1) begin // verilog真不支持+=，我记得，这是sv啊
            // TRANS_LEN的含义是读完一次RW所需的位数需要的总线事务数
            // 
            always @(posedge clock) begin
                if (reset) begin
                    data_read_o[i*AXI_DATA_WIDTH+:AXI_DATA_WIDTH] <= 0;
                end
                    //非对齐且跨越，一定读两次，不用管TRANS_LEN
                else if ( r_hs ) begin // 这不就是hs吗？这样浪费一个门啊
                    if (~aligned & overstep) begin
                        if (len[0]) begin// 奇数位把高位或进来
                            data_read_o[AXI_DATA_WIDTH-1:0] <= data_read_o[AXI_DATA_WIDTH-1:0] | axi_r_data_h;
                        end
                        else begin// 偶数位直接相等
                            data_read_o[AXI_DATA_WIDTH-1:0] <= axi_r_data_l;
                        end
                    end
                    // 非对齐且不跨越，只读一次，按对应位处理即可
                    // 普通读多次，就正常处理即可
                    else if (len == i) begin
                        data_read_o[i*AXI_DATA_WIDTH+:AXI_DATA_WIDTH] <= axi_r_data_l;
                    end
                end
            end
        end
    endgenerate

endmodule
