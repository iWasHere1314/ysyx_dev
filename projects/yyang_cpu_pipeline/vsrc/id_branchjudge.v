`include "defines.v"
module id_branchjudge (
    /* control signals */
    input   [`COMP_TYPE_BUS]    id_branchjudge_comp_type_i,

    /* data signals */
    input   [`DATA_BUS]         id_branchjudge_rs1_data_i,
    input   [`DATA_BUS]         id_branchjudge_rs2_data_i,
    output                      id_branchjudge_ok_o
);
    /* rename */
    wire    [`COMP_TYPE_BUS]    comp_type;
    wire    [`DATA_BUS]         rs1_data;
    wire    [`DATA_BUS]         rs2_data;
    wire                        branchjudge_ok;
    /* rename */

    wire    [`DATA_EXTEND_BUS]  sub_op1;
    wire    [`DATA_EXTEND_BUS]  sub_op2;
    wire    [`DATA_EXTEND_BUS]  sub_res;
    
    wire                        comp_signed;
    wire                        branchjudge_eq;
    wire                        branchjudge_neq;
    wire                        branchjudge_lt;
    wire                        branchjudge_ge;
    wire                        branchjudge_eq_res;
    wire                        branchjudge_neq_res;
    wire                        branchjudge_lt_res;
    wire                        branchjudge_ge_res;
    
    /* rename */
    assign comp_type                    =   id_branchjudge_comp_type_i;
    assign rs1_data                     =   id_branchjudge_rs1_data_i;
    assign rs2_data                     =   id_branchjudge_rs2_data_i;
    assign id_branchjudge_ok_o          =   branchjudge_ok;
    /* rename */

    assign sub_op1                      =   { comp_signed & rs1_data[63], rs1_data };
    assign sub_op2                      =   { comp_signed & rs2_data[63], rs2_data };
    assign sub_res                      =   sub_op1 + ( ~sub_op2 + `DATA_EXTEND_SIZE'b1 );
    
    assign comp_signed                  =   ~( comp_type[2] & comp_type[0] );
    assign branchjudge_eq               =   comp_type == 3'b010;
    assign branchjudge_neq              =   comp_type == 3'b011;
    assign branchjudge_lt               =   comp_type[2:1] == 2'b10;
    assign branchjudge_ge               =   comp_type[2:1] == 2'b11;
    
    assign branchjudge_eq_res           =   sub_res == `DATA_EXTEND_SIZE'b0;
    assign branchjudge_neq_res          =   ~branchjudge_eq_res;//sub_res != `DATA_EXTEND_SIZE'b0;
    assign branchjudge_ge_res           =   sub_res[64] == 1'b0;
    assign branchjudge_lt_res           =   ~branchjudge_ge_res;//sub_res[64] == 1'b1;

    assign branchjudge_ok               =   0 | branchjudge_eq & branchjudge_eq_res
                                              | branchjudge_neq & branchjudge_neq_res
                                              | branchjudge_ge & branchjudge_ge_res
                                              | branchjudge_lt & branchjudge_lt_res;
                                      
endmodule