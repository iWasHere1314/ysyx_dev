`include "defines.v"

module regfile (
    input                   clk,
    input                   rst,
    input                   rd_ena,
    input   [`REG_INDEX]    rs1_index,
    input   [`REG_INDEX]    rs2_index,
    input                   rs1_ena,
    input                   rs2_ena,
    input   [`REG_INDEX]    rd_index,
    input   [`REG_BUS]      rd_data,
    output  [`REG_BUS]      rs1_data,
    output  [`REG_BUS]      rs2_data 
);
    
    reg [`REG_BUS] regfile_r [`REG_NUM-1:1];

    generate
        genvar i;
        for( i=1; i<`REG_NUM; i = i+1 ) begin
            :regfile_op
            always @( posedge clk ) begin
                if( rst == 1'b1 ) begin
                    regfile_r[i] <= `REG_BUS_SIZE'b0;
                end
                else if( rd_index == i && rd_ena ) begin
                    regfile_r[i] <= rd_data;    
                end
                else begin
                    regfile_r[i] <= regfile_r[i];
                end
            end
        end
    endgenerate

    wire [`REG_BUS] rs1_data_pre = rs1_index == `REG_ZERO ? `REG_BUS_SIZE'b0 : regfile_r[rs1_index];
    wire [`REG_BUS] rs2_data_pre = rs2_index == `REG_ZERO ? `REG_BUS_SIZE'b0 : regfile_r[rs2_index];

    assign rs1_data = rs1_ena ? rs1_data_pre: `REG_BUS_SIZE'b0;
    assign rs2_data = rs2_ena ? rs2_data_pre: `REG_BUS_SIZE'b0;

endmodule
