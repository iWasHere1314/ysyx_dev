`include "defines.v"

module cpu(
    input                       clock,
    input                       reset,
    
    input                       if_ready,
    input   [`INST_BUS]         if_data_read,
    input   [1:0]               if_resp,
    output                      if_valid,
    output  [`INST_ADDR_BUS]    if_addr,
    output  [1:0]               if_size,
    output                      if_req,

    output                      cpu_mem_valid,
    input                       cpu_mem_ready,
    input   [`DATA_BUS]         cpu_mem_data_read,
    output  [`DATA_BUS]         cpu_mem_data_write,
    output  [`DATA_ADDR_BUS]    cpu_mem_addr,
    output  [1:0]               cpu_mem_size,
    input   [1:0]               cpu_mem_resp,
    output                      cpu_mem_req
);

    wire                        branchjudge_ok;
    wire    [`DATA_BUS]         rd_data;

    /* self-defined */
    `ifdef DEFINE_PUTCH
    wire                        inst_selfdefine;
    `endif 

    // if
    wire    [`INST_ADDR_BUS]    inst_addr;
    wire    [`INST_BUS]         inst;    
    wire                        inst_valid;
    // id
    /* register control */
    wire    [`REG_INDEX_BUS]    rs1_index;
    wire    [`REG_INDEX_BUS]    rs2_index;
    wire                        rs1_en;
    wire                        rs2_en;
    wire    [`REG_INDEX_BUS]    rd_index;
    wire                        rd_en;
    
    /* instruction type */
    wire                        inst_sltxx;
    wire                        inst_shift;
    wire                        inst_lui;
    wire                        inst_load;
    wire                        inst_jump;
    wire                        inst_word;
    wire                        inst_branch;
    wire                        inst_csr;
    
    /* immediate */
    wire    [`DATA_BUS]         imm_data;
    
    /* memory control */
    wire                        mem_write;
    wire                        mem_read;
    
    /* alu control */
    wire                        alu_src_pc;
    wire                        alu_src_imm;
    wire    [`ALU_OP_BUS]       alu_op;
    
    /* compare */
    wire    [`COMP_TYPE_BUS]    comp_type;
    
    /* shift */
    wire    [`SHIFT_TYPE_BUS]   shift_type;
    wire                        shift_num_src;
    wire    [`IMM_SHIFT_BUS]    imm_shift;
    
    /* store */
    wire    [`STORE_TYPE_BUS]   store_type;
    
    /* load */
    wire    [`LOAD_TYPE_BUS]    load_type;
    
    /* csr */
    wire    [`CSR_INDEX_BUS]    csr_index;
    wire    [`CSR_CTRL_BUS]     csr_ctrl;
    wire                        csr_src;                  
    wire    [`DATA_BUS]         imm_csr;
    wire                        inst_ecall;
    wire                        inst_ebreak;
    wire                        inst_trap;
    wire                        inst_mret;

    // ex
    wire    [`INST_ADDR_BUS]    alu_raw_res;
    wire    [`DATA_BUS]         ex_odata;
    wire                        branchjudge_res;

    // mem
    wire    [`DATA_BUS]         read_data;
    wire                        mem_valid;
    wire    [`DATA_BUS]         mem_data_write;
    wire    [`DATA_ADDR_BUS]    mem_addr;
    wire    [1:0]               mem_size;
    wire                        mem_req;

    // regfile
    wire    [`REG_BUS]          rs1_data;
    wire    [`REG_BUS]          rs2_data;
    
    //csr
    wire    [`DATA_BUS]         csr_read;
    wire                        csr_trap;
    wire    [`INST_ADDR_BUS]    csr_nxt_pc;

    //clint_dstb
    wire                        clint_dstb_ready;
    wire    [`DATA_BUS]         clint_dstb_data_read;
    wire    [1:0]               clint_dstb_resp;

    wire                        clint_dstb_mem_valid;
    wire    [`DATA_BUS]         clint_dstb_mem_data_write;
    wire    [`DATA_ADDR_BUS]    clint_dstb_mem_addr;
    wire    [1:0]               clint_dstb_mem_size;
    wire                        clint_dstb_mem_req;

    wire                        clint_valid;
    wire    [`DATA_BUS]         clint_data_write;
    wire    [`DATA_ADDR_BUS]    clint_addr;
    wire    [1:0]               clint_size;
    wire                        clint_req;

    //clint

    wire                        clint_mtip;
    wire                        clint_ready;
    wire    [`DATA_BUS]         clint_data_read;
    wire    [1:0]               clint_resp;

    //difftest interface                 
    wire    [`REG_BUS]          regs_o  [31:0] ;


    assign branchjudge_ok       =   branchjudge_res & inst_branch;
    assign rd_data              =   inst_trap | inst_mret? csr_nxt_pc
                                    : ( inst_jump? ( inst_addr + `INST_ADDR_SIZE'h4 )
                                    : ( inst_csr? csr_read 
                                    : ( inst_load? read_data:( inst_lui? imm_data: ex_odata ) ) ) );


    if_top my_if_top(
        .clk( clock ),
        .rst( reset ),
        .branchjudge_ok( branchjudge_ok ),
        .inst_jump( inst_jump ),
        .jump_addr( alu_raw_res ),
        .imm_offset( imm_data ),

        .if_ready( if_ready ),
        .if_data_read( if_data_read ),
        .if_resp( if_resp ),

        .inst_addr( inst_addr ),
        .if_valid( if_valid ),
        .if_addr( if_addr ),
        .if_size( if_size ),
        .inst_valid( inst_valid ),
        .inst( inst ),
        .if_req( if_req )
    );

    id_top my_id_top(
        .inst( inst ),
        
        /* interrupt  */
        .csr_trap( csr_trap ),

        /* register control */
        .rs1_index( rs1_index ),
        .rs2_index( rs2_index ),
        .rs1_en( rs1_en ),
        .rs2_en( rs2_en ),
        .rd_index( rd_index ),
        .rd_en( rd_en ),
    
        /* instruction type */
        .inst_sltxx( inst_sltxx ),
        .inst_shift( inst_shift ),
        .inst_lui( inst_lui ),
        .inst_load( inst_load ),
        .inst_jump( inst_jump ),
        .inst_word( inst_word ),
        .inst_branch( inst_branch ),
        .inst_csr( inst_csr ),
        .inst_ecall( inst_ecall ),
        .inst_ebreak( inst_ebreak ),
        .inst_mret( inst_mret ),
        .inst_trap( inst_trap ),

        /* immediate */
        .imm_data( imm_data ),
    
        /* memory control */
        .mem_write( mem_write ),
        .mem_read( mem_read ),
    
        /* alu control */
        .alu_src_pc( alu_src_pc ),
        .alu_src_imm( alu_src_imm ),
        .alu_op( alu_op ),
    
        /* compare */
        .comp_type( comp_type ),
    
        /* shift */
        .shift_type( shift_type ),
        .shift_num_src( shift_num_src ),
        .imm_shift( imm_shift ),
    
        /* store */
        .store_type( store_type ),
    
        /* load */
        .load_type( load_type ),

        /* csr */
        .csr_index( csr_index ),
        .csr_ctrl( csr_ctrl ),
        .csr_src( csr_src ),                   
        .imm_csr( imm_csr )

        /* instruction */
        `ifdef DEFINE_PUTCH
        ,
        .inst_selfdefine( inst_selfdefine )
        `endif
    );
    
    ex_top my_ex_top(
        /* control signals */
        // alu
        .alu_src_pc( alu_src_pc ),
        .alu_src_imm( alu_src_imm ),
        .alu_op( alu_op ),
        // word instruction
        .inst_word( inst_word ),
        // branch or sltxx
        .inst_sltxx( inst_sltxx ),
        .comp_type( comp_type ),
        // shift          
        .inst_shift( inst_shift ),
        .shift_num_src( shift_num_src ),
        .shift_type( shift_type ),

        /* data */
        .pc( inst_addr ),
        .rs1_data( rs1_data ),
        .rs2_data( rs2_data ),
        .imm_data( imm_data ),
        .imm_shift( imm_shift ),

        /* output */
        .alu_raw_res( alu_raw_res ),
        .ex_odata( ex_odata ),
        .branchjudge_res( branchjudge_res )
    );
    
    regfile my_regfile(
        .clk( clock ),
        .rst( reset ),
        .rd_en( rd_en & inst_valid ),
        .rs1_index( rs1_index ),
        .rs2_index( rs2_index ),
        .rs1_en( rs1_en ),
        .rs2_en( rs2_en ),
        .rd_index( rd_index ),
        .rd_data( rd_data ),
        .rs1_data( rs1_data ),
        .rs2_data( rs2_data )
        `ifdef DEFINE_DIFFTEST
        /* difftest interface */
                             ,
        .regs_o( regs_o ) 
        `endif
    );

    mem_top my_mem_top(
        .clk( clock ),
        .rst( reset ),

        .store_type( store_type ),
        .load_type( load_type ),
        .mem_write( mem_write ),
        .mem_read( mem_read ),
        .data_addr( alu_raw_res ),
        .write_data( rs2_data ),
        .read_data( read_data ),
        .inst_valid( inst_valid ),

        .mem_valid( mem_valid ),
        .mem_ready( clint_dstb_ready ),
        .mem_data_read( clint_dstb_data_read ),
        .mem_data_write( mem_data_write ),
        .mem_addr( mem_addr ),
        .mem_size( mem_size ),
        .mem_resp( clint_dstb_resp ),
        .mem_req( mem_req )
    );
    csr_top my_csr_top(
        .clk( clock ),
        .rst( reset ),

        .inst_addr( inst_addr ),
        .inst_valid( inst_valid ),
        .csr_index( csr_index ),
        .rs1_data( rs1_data ),
        .imm_csr( imm_csr ),
        .csr_ctrl( csr_ctrl ),
        .csr_src( csr_src ),
        .inst_trap( inst_trap ),
        .inst_mret( inst_mret ),
        .clint_mtip( clint_mtip ),
        .inst_ecall( inst_ecall ),  
        .inst_ebreak( inst_ebreak ),

        .csr_read( csr_read ),
        .csr_trap( csr_trap ),
        .csr_nxt_pc( csr_nxt_pc )
    );

    clint_dstb my_clint_dstb (
        .clint_dstb_valid( mem_valid ),
        .clint_dstb_ready( clint_dstb_ready ),
        .clint_dstb_data_read( clint_dstb_data_read ),
        .clint_dstb_data_write( mem_data_write ),
        .clint_dstb_addr( mem_addr ),
        .clint_dstb_size( mem_size ),
        .clint_dstb_resp( clint_dstb_resp ),
        .clint_dstb_req( mem_req ),

        .clint_dstb_mem_valid( cpu_mem_valid ),
        .clint_dstb_mem_ready( cpu_mem_ready ),
        .clint_dstb_mem_data_read( cpu_mem_data_read ),
        .clint_dstb_mem_data_write( cpu_mem_data_write ),
        .clint_dstb_mem_addr( cpu_mem_addr ),
        .clint_dstb_mem_size( cpu_mem_size ),
        .clint_dstb_mem_resp( cpu_mem_resp ),
        .clint_dstb_mem_req( cpu_mem_req ),

        .clint_valid( clint_valid ),
        .clint_ready( clint_ready ),
        .clint_data_read( clint_data_read ),
        .clint_data_write( clint_data_write ),
        .clint_addr( clint_addr ),
        .clint_size( clint_size ),
        .clint_resp( clint_resp ),
        .clint_req( clint_req )
    );

    clint my_clint(
        .clk( clock ),
        .rst( reset ),

        .clint_mtip( clint_mtip ),

        .clint_valid( clint_valid ),
        .clint_data_write( clint_data_write ),
        .clint_addr( clint_addr ),
        .clint_size( clint_size ),
        .clint_req( clint_req ),

        .clint_ready( clint_ready ),
        .clint_data_read( clint_data_read ),
        .clint_resp( clint_resp )
    );
`ifdef DEFINE_DIFFTEST
    // Difftest
    reg cmt_wen;
    reg [7:0] cmt_wdest;
    reg [`REG_BUS] cmt_wdata;
    reg [`REG_BUS] cmt_pc;
    reg [31:0] cmt_inst;
    reg cmt_valid;
    reg trap;
    reg [7:0] trap_code;
    reg [63:0] cycleCnt;
    reg [63:0] instrCnt;
    reg [`REG_BUS] regs_diff [ 31:0 ];
    
    `ifdef DEFINE_PUTCH
    reg cmt_skip;
    `endif

    // wire inst_valid = ( inst_addr != `PC_START) | (inst != 0);
    always @(negedge clock) begin
        if (reset) begin
            {cmt_wen, cmt_wdest, cmt_wdata, cmt_pc, cmt_inst, cmt_valid, trap, trap_code, cycleCnt, instrCnt} <= 0;
        end
        else if (~trap) begin
            cmt_wen <= rd_en & inst_valid;
            cmt_wdest <= {3'd0, rd_index};
            cmt_wdata <= rd_data;
            cmt_pc <= inst_addr;
            cmt_inst <= inst;
            cmt_valid <= inst_valid & ( ( inst_addr != `PC_START) | (inst != 0) ) ;
        
        	    regs_diff <= regs_o;

            trap <= inst[6:0] == 7'h6b;
            trap_code <= regs_o[10][7:0];
            cycleCnt <= cycleCnt + 1;
            instrCnt <= instrCnt + inst_valid;
            `ifdef DEFINE_PUTCH
            cmt_skip <= inst_selfdefine | inst_csr ;
            `endif
        end
    end

    `ifdef DEFINE_PUTCH
    always @( posedge inst_selfdefine ) begin
        $write("%c", regs_o[10][7:0]);
    end
    `endif 
    DifftestInstrCommit DifftestInstrCommit(
      .clock              (clock),
      .coreid             (0),
      .index              (0),
      .valid              (cmt_valid),
      .pc                 (cmt_pc),
      .instr              (cmt_inst),
      .skip               (
                            `ifdef DEFINE_PUTCH
                                cmt_skip
                            `else 
                                0
                            `endif
                            ),
      .isRVC              (0),
      .scFailed           (0),
      .wen                (cmt_wen),
      .wdest              (cmt_wdest),
      .wdata              (cmt_wdata)
    );

    DifftestArchIntRegState DifftestArchIntRegState (
      .clock              (clock),
      .coreid             (0),
      .gpr_0              (regs_diff[0]),
      .gpr_1              (regs_diff[1]),
      .gpr_2              (regs_diff[2]),
      .gpr_3              (regs_diff[3]),
      .gpr_4              (regs_diff[4]),
      .gpr_5              (regs_diff[5]),
      .gpr_6              (regs_diff[6]),
      .gpr_7              (regs_diff[7]),
      .gpr_8              (regs_diff[8]),
      .gpr_9              (regs_diff[9]),
      .gpr_10             (regs_diff[10]),
      .gpr_11             (regs_diff[11]),
      .gpr_12             (regs_diff[12]),
      .gpr_13             (regs_diff[13]),
      .gpr_14             (regs_diff[14]),
      .gpr_15             (regs_diff[15]),
      .gpr_16             (regs_diff[16]),
      .gpr_17             (regs_diff[17]),
      .gpr_18             (regs_diff[18]),
      .gpr_19             (regs_diff[19]),
      .gpr_20             (regs_diff[20]),
      .gpr_21             (regs_diff[21]),
      .gpr_22             (regs_diff[22]),
      .gpr_23             (regs_diff[23]),
      .gpr_24             (regs_diff[24]),
      .gpr_25             (regs_diff[25]),
      .gpr_26             (regs_diff[26]),
      .gpr_27             (regs_diff[27]),
      .gpr_28             (regs_diff[28]),
      .gpr_29             (regs_diff[29]),
      .gpr_30             (regs_diff[30]),
      .gpr_31             (regs_diff[31])
    );
    DifftestTrapEvent DifftestTrapEvent(
      .clock              (clock),
      .coreid             (0),
      .valid              (trap),
      .code               (trap_code),
      .pc                 (cmt_pc),
      .cycleCnt           (cycleCnt),
      .instrCnt           (instrCnt)
    );
    DifftestCSRState DifftestCSRState(
      .clock              (clock),
      .coreid             (0),
      .priviledgeMode     (0),
      .mstatus            (0),
      .sstatus            (0),
      .mepc               (0),
      .sepc               (0),
      .mtval              (0),
      .stval              (0),
      .mtvec              (0),
      .stvec              (0),
      .mcause             (0),
      .scause             (0),
      .satp               (0),
      .mip                (0),
      .mie                (0),
      .mscratch           (0),
      .sscratch           (0),
      .mideleg            (0),
      .medeleg            (0)
    );
    
    DifftestArchFpRegState DifftestArchFpRegState(
      .clock              (clock),
      .coreid             (0),
      .fpr_0              (0),
      .fpr_1              (0),
      .fpr_2              (0),
      .fpr_3              (0),
      .fpr_4              (0),
      .fpr_5              (0),
      .fpr_6              (0),
      .fpr_7              (0),
      .fpr_8              (0),
      .fpr_9              (0),
      .fpr_10             (0),
      .fpr_11             (0),
      .fpr_12             (0),
      .fpr_13             (0),
      .fpr_14             (0),
      .fpr_15             (0),
      .fpr_16             (0),
      .fpr_17             (0),
      .fpr_18             (0),
      .fpr_19             (0),
      .fpr_20             (0),
      .fpr_21             (0),
      .fpr_22             (0),
      .fpr_23             (0),
      .fpr_24             (0),
      .fpr_25             (0),
      .fpr_26             (0),
      .fpr_27             (0),
      .fpr_28             (0),
      .fpr_29             (0),
      .fpr_30             (0),
      .fpr_31             (0)
    );
endmodule

`endif