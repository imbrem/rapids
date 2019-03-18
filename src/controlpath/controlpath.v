module controlpath(
    input clk,
    input[31:0] instruction,
    output program_counter_inc,
    output[2:0] alu_op,
    output alu_form,
    output[1:0] alu_vec_perci,
    output const_a,
    output constant,
    output[3:0] alu_a_select,
    output[3:0] alu_b_select,
    output[3:0] alu_c_select,
    output[3:0] alu_d_select,
    output[3:0] alu_Y1_select,
    output[3:0] alu_Y2_select,
    output[1:0] alu_write
  );
endmodule
