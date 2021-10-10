`include "defines.v"
module mem_top(
    input                       clk,
    input                       rst,

    /* control signals */
    input                       mem_top_inst_valid_i,
    input   [`REG_INDEX_BUS]    mem_top_ex2mem_rs1_index_i,
    input   [`REG_INDEX_BUS]    mem_top_ex2mem_rs2_index_i,
    input   [`REG_INDEX_BUS]    mem_top_mem2wb_rd_index_i,

    input                       mem_top_ex2mem_rs1_en_i,
    input                       mem_top_ex2mem_rs2_en_i,
    input                       mem_top_mem2wb_rd_en_i,

    input   [`CSR_INDEX_BUS]    mem_top_csr_index_i,
    input                       mem_top_inst_csr_i,
    input                       mem_top_inst_load_i,
    input                       mem_top_mem_write_i,
    input                       mem_top_mem_read_i,
    input   [`STORE_TYPE_BUS]   mem_top_store_type_i,
    input   [`LOAD_TYPE_BUS]    mem_top_load_type_i,
    input                       mem_top_csr_src_i,
    input   [`CSR_CTRL_BUS]     mem_top_csr_ctrl_i,
    input                       mem_top_inst_ecall_i,
    input                       mem_top_inst_ebreak_i,
    input                       mem_top_inst_mret_i,
    input                       mem_top_inst_trap_i,

    input                       mem_top_intp_en_i,


    output  [`INST_ADDR_BUS]    mem_top_csr_nxt_pc_o,
    output                      mem_top_intp_en_o,
    output                      mem_top_csr_trap_o,

    output                      mem_top_access_ok_o,
    /* data signals */
    input   [`REG_BUS]          mem_top_ex2mem_rs1_data_i,
    input   [`REG_BUS]          mem_top_ex2mem_rs2_data_i,
    input   [`DATA_BUS]         mem_top_imm_data_i,
    input   [`DATA_BUS]         mem_top_ex2mem_rd_data_i,
    input   [`DATA_BUS]         mem_top_mem2wb_rd_data_i,
    input   [`INST_ADDR_BUS]    mem_top_ex2mem_inst_addr_i,

    output  [`DATA_BUS]         mem_top_rd_data_o,

    /* bus interface */
    output                      mem_top_mem_valid_o,
    input                       mem_top_mem_ready_i,
    input   [`DATA_BUS]         mem_top_mem_data_read_i,
    output  [`DATA_BUS]         mem_top_mem_data_write_o,
    output  [`DATA_ADDR_BUS]    mem_top_mem_addr_o,
    output  [1:0]               mem_top_mem_size_o,
    input   [1:0]               mem_top_mem_resp_i,
    output                      mem_top_mem_req_o
    `ifdef DEFINE_DIFFTEST
    ,
    output                      mem_top_csr_skip_o,
    output  [`REG_BUS]          mem_top_mstatus_o,
    output  [`REG_BUS]          mem_top_mtvec_o,
    output  [`REG_BUS]          mem_top_mepc_o,
    output  [`REG_BUS]          mem_top_mcause_o,
    output  [`REG_BUS]          mem_top_mip_o,
    output  [`REG_BUS]          mem_top_mie_o,
    output  [`REG_BUS]          mem_top_mscratch_o,
    output  [31:0]              mem_top_cause_o,
    output                      mem_top_clint_dstb_skip_o
    `endif
);

    wire                        mem_interface_access_ok_o;
    wire    [`DATA_BUS]         mem_interface_read_data_o;
    wire                        mem_interface_valid_o;
    wire    [`DATA_BUS]         mem_interface_data_write_o;
    wire    [`DATA_ADDR_BUS]    mem_interface_addr_o;
    wire    [1:0]               mem_interface_size_o;
    wire                        mem_interface_req_o;

    wire                        mem_csr_csr_trap_o;
    wire    [`INST_ADDR_BUS]    mem_csr_csr_nxt_pc_o;
    wire    [`DATA_BUS]         mem_csr_csr_read_o;
    
    `ifdef DEFINE_DIFFTEST
    wire                        mem_csr_csr_skip_o;
    wire    [`REG_BUS]          mem_csr_mstatus_o;
    wire    [`REG_BUS]          mem_csr_mtvec_o;
    wire    [`REG_BUS]          mem_csr_mepc_o;
    wire    [`REG_BUS]          mem_csr_mcause_o;
    wire    [`REG_BUS]          mem_csr_mip_o;
    wire    [`REG_BUS]          mem_csr_mie_o;
    wire    [`REG_BUS]          mem_csr_mscratch_o;
    wire    [31:0]              mem_csr_cause_o;
    `endif

    wire                        mem_clint_dstb_ready_o;
    wire    [`DATA_BUS]         mem_clint_dstb_data_read_o;
    wire    [1:0]               mem_clint_dstb_resp_o;
    wire                        mem_clint_dstb_mem_valid_o;

    wire    [`DATA_BUS]         mem_clint_dstb_mem_data_write_o;
    wire    [`DATA_ADDR_BUS]    mem_clint_dstb_mem_addr_o;
    wire    [1:0]               mem_clint_dstb_mem_size_o;
    wire                        mem_clint_dstb_mem_req_o;
    
    wire                        mem_clint_dstb_clint_valid_o;
    wire    [`DATA_BUS]         mem_clint_dstb_clint_data_write_o;
    wire    [`DATA_ADDR_BUS]    mem_clint_dstb_clint_addr_o;
    wire    [1:0]               mem_clint_dstb_clint_size_o;
    wire                        mem_clint_dstb_clint_req_o;
    
    `ifdef DEFINE_DIFFTEST
    wire                        mem_clint_dstb_skip_o;
    `endif


    wire                        mem_clint_clint_mtip_o;
    wire                        mem_clint_clint_update_o;
    wire                        mem_clint_clint_ready_o;
    wire    [`DATA_BUS]         mem_clint_clint_data_read_o;
    wire    [1:0]               mem_clint_clint_resp_o;

    wire                        mem_forward_ex_rs1_src_ex2mem_o;
    wire                        mem_forward_ex_rs1_src_mem2wb_o;
    wire                        mem_forward_ex_rs2_src_ex2mem_o;
    wire                        mem_forward_ex_rs2_src_mem2wb_o;

    wire    [`DATA_BUS]         rs1_data;
    wire    [`DATA_BUS]         rs2_data;

    assign rs1_data                         =     ( { 64 { mem_forward_ex_rs1_src_ex2mem_o } } & mem_top_ex2mem_rs1_data_i )
                                                | ( { 64 { mem_forward_ex_rs1_src_mem2wb_o } } & mem_top_mem2wb_rd_data_i );
    assign rs2_data                         =     ( { 64 { mem_forward_ex_rs2_src_ex2mem_o } } & mem_top_ex2mem_rs2_data_i )
                                                | ( { 64 { mem_forward_ex_rs2_src_mem2wb_o } } & mem_top_mem2wb_rd_data_i );
    
    assign mem_top_csr_nxt_pc_o             =   mem_csr_csr_nxt_pc_o;
    assign mem_top_intp_en_o                =   mem_top_intp_en_i;
    assign mem_top_csr_trap_o               =   mem_csr_csr_trap_o;
    assign mem_top_access_ok_o              =   mem_interface_access_ok_o;
    assign mem_top_rd_data_o                =     ( { 64 { mem_top_inst_load_i } } &  mem_interface_read_data_o )
                                                | ( { 64 { mem_top_inst_csr_i } } & mem_csr_csr_read_o )
                                                | ( { 64 { ~mem_top_inst_load_i & ~mem_top_inst_csr_i } } & mem_top_ex2mem_rd_data_i );

    assign mem_top_mem_valid_o              =   mem_clint_dstb_mem_valid_o;
    assign mem_top_mem_data_write_o         =   mem_clint_dstb_mem_data_write_o;
    assign mem_top_mem_addr_o               =   mem_clint_dstb_mem_addr_o;
    assign mem_top_mem_size_o               =   mem_clint_dstb_mem_size_o;
    assign mem_top_mem_req_o                =   mem_clint_dstb_mem_req_o;
   
    `ifdef DEFINE_DIFFTEST
    assign mem_top_csr_skip_o               =   mem_csr_csr_skip_o;
    assign mem_top_mstatus_o                =   mem_csr_mstatus_o;
    assign mem_top_mtvec_o                  =   mem_csr_mtvec_o;
    assign mem_top_mepc_o                   =   mem_csr_mepc_o;
    assign mem_top_mcause_o                 =   mem_csr_mcause_o;  
    assign mem_top_mip_o                    =   mem_csr_mip_o;
    assign mem_top_mie_o                    =   mem_csr_mie_o;
    assign mem_top_mscratch_o               =   mem_csr_mscratch_o;
    assign mem_top_cause_o                  =   mem_csr_cause_o;
    assign mem_top_clint_dstb_skip_o        =   mem_clint_dstb_skip_o;

    `endif
   
    mem_interface my_mem_interface(
        .clk( clk ),
        .rst( rst ),
        .mem_interface_intp_en_i( mem_top_intp_en_i ),
        .mem_interface_access_ok_o( mem_interface_access_ok_o ),

        /* cpu side */
        .mem_interface_inst_valid_i( mem_top_inst_valid_i ),
        .mem_interface_store_type_i( mem_top_store_type_i ),
        .mem_interface_load_type_i( mem_top_load_type_i ),
        .mem_interface_mem_write_i( mem_top_mem_write_i ),
        .mem_interface_mem_read_i( mem_top_mem_read_i ),
        .mem_interface_data_addr_i( mem_top_ex2mem_rd_data_i ),
        .mem_interface_write_data_i( rs2_data ),
        .mem_interface_read_data_o( mem_interface_read_data_o ),

        /* access side */
        .mem_interface_valid_o( mem_interface_valid_o ),
        .mem_interface_ready_i( mem_clint_dstb_ready_o ),
        .mem_interface_data_read_i( mem_clint_dstb_data_read_o ),
        .mem_interface_data_write_o( mem_interface_data_write_o ),
        .mem_interface_addr_o( mem_interface_addr_o ),
        .mem_interface_size_o( mem_interface_size_o ),
        .mem_interface_resp_i( mem_clint_dstb_resp_o ),
        .mem_interface_req_o( mem_interface_req_o )
    );

    mem_csr my_mem_csr(
        .clk( clk ),
        .rst( rst ),

        .mem_csr_inst_valid_i( mem_top_inst_valid_i ),

        .mem_csr_intp_en_i( mem_top_intp_en_i ),

        .mem_csr_csr_index_i( mem_top_csr_index_i ),
        .mem_csr_rs1_data_i( rs1_data ),
        .mem_csr_imm_csr_i( mem_top_imm_data_i ),
        .mem_csr_csr_ctrl_i( mem_top_csr_ctrl_i ),
        .mem_csr_inst_addr_i( mem_top_ex2mem_inst_addr_i ),
        .mem_csr_csr_src_i( mem_top_csr_src_i ),
        .mem_csr_inst_trap_i( mem_top_inst_trap_i ),
        .mem_csr_inst_mret_i( mem_top_inst_mret_i ),
        .mem_csr_clint_mtip_i( mem_clint_clint_mtip_o ),
        .mem_csr_clint_update_i( mem_clint_clint_update_o ),
        .mem_csr_inst_ecall_i( mem_top_inst_ecall_i ),
        .mem_csr_inst_ebreak_i( mem_top_inst_ebreak_i ),

        .mem_csr_csr_trap_o( mem_csr_csr_trap_o ),
        .mem_csr_csr_nxt_pc_o( mem_csr_csr_nxt_pc_o ),
        .mem_csr_csr_read_o( mem_csr_csr_read_o )
        `ifdef DEFINE_DIFFTEST
        ,
        .mem_csr_csr_skip_o( mem_csr_csr_skip_o ),
        .mem_csr_mstatus_o( mem_csr_mstatus_o ),
        .mem_csr_mtvec_o( mem_csr_mtvec_o ),
        .mem_csr_mepc_o( mem_csr_mepc_o ),
        .mem_csr_mcause_o( mem_csr_mcause_o ),
        .mem_csr_mip_o( mem_csr_mip_o),
        .mem_csr_mie_o( mem_csr_mie_o ),
        .mem_csr_mscratch_o( mem_csr_mscratch_o ),
        .mem_csr_cause_o( mem_csr_cause_o )
        `endif
    );

mem_clint_dstb my_mem_clint_dstb(
    /* input side */
    .mem_clint_dstb_valid_i( mem_interface_valid_o ),
    .mem_clint_dstb_ready_o( mem_clint_dstb_ready_o ),
    .mem_clint_dstb_data_read_o( mem_clint_dstb_data_read_o ),
    .mem_clint_dstb_data_write_i( mem_interface_data_write_o ),
    .mem_clint_dstb_addr_i( mem_interface_addr_o ),
    .mem_clint_dstb_size_i( mem_interface_size_o ),
    .mem_clint_dstb_resp_o( mem_clint_dstb_resp_o ),
    .mem_clint_dstb_req_i( mem_interface_req_o ),

    /* mem side */
    .mem_clint_dstb_mem_valid_o( mem_clint_dstb_mem_valid_o ),
    .mem_clint_dstb_mem_ready_i( mem_top_mem_ready_i ),
    .mem_clint_dstb_mem_data_read_i( mem_top_mem_data_read_i ),
    .mem_clint_dstb_mem_data_write_o( mem_clint_dstb_mem_data_write_o ),
    .mem_clint_dstb_mem_addr_o( mem_clint_dstb_mem_addr_o ),
    .mem_clint_dstb_mem_size_o( mem_clint_dstb_mem_size_o ),
    .mem_clint_dstb_mem_resp_i( mem_top_mem_resp_i ),
    .mem_clint_dstb_mem_req_o( mem_clint_dstb_mem_req_o ),

    /* clint side */
    .mem_clint_dstb_clint_valid_o( mem_clint_dstb_clint_valid_o ),
    .mem_clint_dstb_clint_ready_i(  mem_clint_clint_ready_o ),
    .mem_clint_dstb_clint_data_read_i( mem_clint_clint_data_read_o ),
    .mem_clint_dstb_clint_data_write_o( mem_clint_dstb_clint_data_write_o ),
    .mem_clint_dstb_clint_addr_o( mem_clint_dstb_clint_addr_o ),
    .mem_clint_dstb_clint_size_o( mem_clint_dstb_clint_size_o ),
    .mem_clint_dstb_clint_resp_i( mem_clint_clint_resp_o ),
    .mem_clint_dstb_clint_req_o( mem_clint_dstb_clint_req_o )
    
    `ifdef DEFINE_DIFFTEST
    ,
    .mem_clint_dstb_skip_o( mem_clint_dstb_skip_o )
    `endif
);

mem_clint my_mem_clint(
    .clk( clk ),
    .rst( rst ),

    .mem_clint_clint_mtip_o( mem_clint_clint_mtip_o ),
    .mem_clint_clint_update_o( mem_clint_clint_update_o ),
    .mem_clint_clint_valid_i( mem_clint_dstb_clint_valid_o ),
    .mem_clint_clint_data_write_i( mem_clint_dstb_clint_data_write_o ),
    .mem_clint_clint_addr_i( mem_clint_dstb_clint_addr_o ),
    .mem_clint_clint_size_i( mem_clint_dstb_clint_size_o ),
    .mem_clint_clint_req_i( mem_clint_dstb_clint_req_o ),

    .mem_clint_clint_ready_o( mem_clint_clint_ready_o ),
    .mem_clint_clint_data_read_o( mem_clint_clint_data_read_o ),
    .mem_clint_clint_resp_o( mem_clint_clint_resp_o )
);

mem_forward my_mem_forward(
    .mem_forward_ex2mem_rs1_en_i( mem_top_ex2mem_rs1_en_i ),
    .mem_forward_ex2mem_rs2_en_i( mem_top_ex2mem_rs2_en_i ),
    .mem_forward_mem2wb_rd_en_i( mem_top_mem2wb_rd_en_i ),
    .mem_forward_ex2mem_rs1_index_i( mem_top_ex2mem_rs1_index_i ),
    .mem_forward_ex2mem_rs2_index_i( mem_top_ex2mem_rs2_index_i ),
    .mem_forward_mem2wb_rd_index_i( mem_top_mem2wb_rd_index_i ),
    
    .mem_forward_ex_rs1_src_ex2mem_o( mem_forward_ex_rs1_src_ex2mem_o ),
    .mem_forward_ex_rs1_src_mem2wb_o( mem_forward_ex_rs1_src_mem2wb_o ),
    .mem_forward_ex_rs2_src_ex2mem_o( mem_forward_ex_rs2_src_ex2mem_o ),
    .mem_forward_ex_rs2_src_mem2wb_o( mem_forward_ex_rs2_src_mem2wb_o )
);

    // wire temp   = ( mem_top_ex2mem_rd_data_i == 64'h00000000800004c0 );
    // always @( posedge clk ) begin
    //     if( temp & mem_top_mem_write_i & mem_top_inst_valid_i ) begin
    //         $write("%hwrite %h\n", mem_top_ex2mem_inst_addr_i, rs2_data );
    //     end
    //     if( temp & mem_top_mem_read_i & mem_top_inst_valid_i ) begin
    //         $write("%hread %h\n", mem_top_ex2mem_inst_addr_i, mem_top_rd_data_o );
    //     end
    // end
endmodule