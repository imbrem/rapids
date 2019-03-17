module alu_instruction_decoder (
  input[31:0] instruction,
  output[3:0] alu_op,
  output[1:0] alu_vector_perci,
  output alu_form,
  output const_a,
  output[3:0] alu_a_select,
  output[3:0] alu_b_select,
  output[3:0] alu_c_select,
  output[3:0] alu_d_select,
  output[3:0] alu_Y1_select,
  output[3:0] alu_Y2_select,
  output[1:0] write,
  );
  wire[2:0] discard_0;
  wire[5:0] discard_1
  assign {
    discard_0,
    const_a,
    alu_op,
    form,
    alu_vector_perci, 
    discard_1,
    alu_a_select,
    alu_b_select,
    alu_c_select,
    alu_d_select
    } = instruction;
endmodule
