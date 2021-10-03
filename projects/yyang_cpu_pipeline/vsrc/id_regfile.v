`include "defines.v"

module id_regfile(
    input                       clk,
    input                       rst,

    /* control signals */
    input                       id_regfile_inst_valid_i,
    input                       id_regfile_rd_en_i,
    input                       id_regfile_rs1_en_i,
    input                       id_regfile_rs2_en_i,
    input   [`REG_INDEX_BUS]    id_regfile_rd_index_i,
    input   [`REG_INDEX_BUS]    id_regfile_rs1_index_i,
    input   [`REG_INDEX_BUS]    id_regfile_rs2_index_i,

    /* data signals */
    input   [`REG_BUS]          id_regfile_rd_data_i,
    output  [`REG_BUS]          id_regfile_rs1_data_o,
    output  [`REG_BUS]          id_regfile_rs2_data_o

    `ifdef DEFINE_DIFFTEST
    /* difftest interface */
    ,
    output  [`REG_BUS]          id_regfile_regs_o  [31:0] 
    `endif

);
    
    reg [`REG_BUS] regfile_r [`REG_NUM-1:1];

    genvar i;
    generate
        for( i=1; i<`REG_NUM; i = i+1 ) begin
            :regfile_op
            always @( posedge clk ) begin
                if( rst ) begin
                    regfile_r[i] <= `REG_BUS_SIZE'b0;
                end
                else if( id_regfile_inst_valid_i & ( id_regfile_rd_index_i == i && id_regfile_rd_en_i ) ) begin
                    regfile_r[i] <= id_regfile_rd_data_i;    
                end
                else begin
                    regfile_r[i] <= regfile_r[i];
                end
            end
        end
    endgenerate

`ifdef DEFINE_DIFFTEST
    generate
        assign id_regfile_regs_o[0] = `DATA_BUS_SIZE'b0;
		for (i = 1; i < `REG_NUM; i = i + 1) begin
			:reg_o_op
            assign id_regfile_regs_o[i] = ( id_regfile_rd_en_i & ( id_regfile_rd_index_i == i ) ) ? 
                                            id_regfile_rd_data_i : regfile_r[i];
		end
	endgenerate
`endif

    wire [`REG_BUS] rs1_data_pre = id_regfile_rs1_index_i == 5'b0 ? `REG_BUS_SIZE'b0 : regfile_r[id_regfile_rs1_index_i];
    wire [`REG_BUS] rs2_data_pre = id_regfile_rs2_index_i == 5'b0 ? `REG_BUS_SIZE'b0 : regfile_r[id_regfile_rs2_index_i];

    assign id_regfile_rs1_data_o = id_regfile_rs1_en_i ? rs1_data_pre: `REG_BUS_SIZE'b0;
    assign id_regfile_rs2_data_o = id_regfile_rs2_en_i ? rs2_data_pre: `REG_BUS_SIZE'b0;

endmodule
