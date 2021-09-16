`include "defines.v"

module regfile (
    input                       clk,
    input                       rst,
    input                       rd_en,
    input   [`REG_INDEX_BUS]    rs1_index,
    input   [`REG_INDEX_BUS]    rs2_index,
    input                       rs1_en,
    input                       rs2_en,
    input   [`REG_INDEX_BUS]    rd_index,
    input   [`REG_BUS]          rd_data,
    output  [`REG_BUS]          rs1_data,
    output  [`REG_BUS]          rs2_data
    // /* difftest interface */
    //                                     ,
    // output  [`REG_BUS]          regs_o  [31:0] 
);
    
    reg [`REG_BUS] regfile_r [`REG_NUM-1:1];

    genvar i;
    generate
        for( i=1; i<`REG_NUM; i = i+1 ) begin
            :regfile_op
            always @( posedge clk ) begin
                if( rst == 1'b1 ) begin
                    regfile_r[i] <= `REG_BUS_SIZE'b0;
                end
                else if( rd_index == i && rd_en ) begin
                    regfile_r[i] <= rd_data;    
                end
                else begin
                    regfile_r[i] <= regfile_r[i];
                end
            end
        end
    endgenerate

    // generate
    //     assign regs_o[0] = `DATA_BUS_SIZE'b0;
	// 	for (i = 1; i < `REG_NUM; i = i + 1) begin
	// 		:reg_o_op
    //         assign regs_o[i] = ( rd_en & ( rd_index == i ) ) ? rd_data : regfile_r[i];
	// 	end
	// endgenerate

    wire [`REG_BUS] rs1_data_pre = rs1_index == `REG_ZERO ? `REG_BUS_SIZE'b0 : regfile_r[rs1_index];
    wire [`REG_BUS] rs2_data_pre = rs2_index == `REG_ZERO ? `REG_BUS_SIZE'b0 : regfile_r[rs2_index];

    assign rs1_data = rs1_en ? rs1_data_pre: `REG_BUS_SIZE'b0;
    assign rs2_data = rs2_en ? rs2_data_pre: `REG_BUS_SIZE'b0;

endmodule
