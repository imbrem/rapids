module controlpath(
    input clk,
    input[31:0] instruction,
    output pc_inc,
    output[2:0] alu_op,
    output alu_form,
    output[1:0] alu_vec_perci,
    output[3:0] alu_config,
    output const_c,
    output[31:0] constant,
    output[3:0] alu_a_select,
    output[3:0] alu_b_select,
    output[3:0] alu_c_select,
    output[3:0] alu_d_select,
    output[3:0] alu_Y1_select,
    output[3:0] alu_Y2_select,
    output[1:0] alu_write,
    output[3:0] copy_select
  );

  reg[3:0] current_state, next_state;
  wire invalid_instruction;

  //controlpath needs mux for different type of operations such as PC
  alu_instruction_decoder d(
    .instruction(instruction),
    .invalid_instruction(invalid_instruction),
    .alu_op(alu_op),
    .alu_vec_perci(alu_vec_perci),
    .alu_form(alu_form),
    .alu_config(alu_config),
    .const_c(const_c),
    .constant(constant),
    .alu_a_select(alu_a_select),
    .alu_b_select(alu_b_select),
    .alu_c_select(alu_c_select),
    .alu_d_select(alu_d_select),
    .alu_Y1_select(alu_Y1_select),
    .alu_Y2_select(alu_Y2_select),
    .copy_select(copy_select)
    );

endmodule
