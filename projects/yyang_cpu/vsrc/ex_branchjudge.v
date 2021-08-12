`include "defines.v"
module ex_branchjudge (
    /* control signals */
    input   [`COMP_TYPE_BUS]    comp_type, 

    /* data */
    input   [`DATA_EXTEND_BUS]  alu_res_data,

    /* output */
    output  [`DATA_BUS]         branchjudge_res_data
);
    wire branchjudge_eq;
    wire branchjudge_neq;
    wire branchjudge_lt;
    wire branchjudge_ge;
    
    wire branchjudge_eq_res;
    wire branchjudge_neq_res;
    wire branchjudge_lt_res;
    wire branchjudge_ge_res;
    wire branchjudge_res_pre;

    assign branchjudge_eq       =   comp_type == 3'b010;
    assign branchjudge_neq      =   comp_type == 3'b011;
    assign branchjudge_lt       =   comp_type[2:1] == 2'b10;
    assign branchjudge_ge       =   comp_type[2:1] == 2'b11;

    assign branchjudge_eq_res   =   alu_res_data == `DATA_EXTEND_SIZE'b0;
    assign branchjudge_neq_res  =   alu_res_data != `DATA_EXTEND_SIZE'b0;
    assign branchjudge_ge_res   =   alu_res_data[64] == 1'b0;
    assign branchjudge_le_res   =   alu_res_data[64] == 1'b1;

    assign branchjudge_res_pre  =   0 | branchjudge_eq & branchjudge_eq_res
                                      | branchjudge_neq & branchjudge_neq_res
                                      | branchjudge_ge & branchjudge_ge_res
                                      | branchjudge_lt & branchjudge_le_res;
                                      
    assign branchjudge_res_data = { 63'b0, branchjudge_res_pre };

endmodule
