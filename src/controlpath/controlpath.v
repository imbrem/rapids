module controlpath(
    input clk,
    input[31:0] instruction,

    output program_counter_inc,

    output[2:0] alu_op,
    output form.
    output[1:0] vec,
    output[3:0] alu_a_select,
    output[3:0] alu_b_select,
    output[3:0] alu_c_select,
    output[3:0] alu_d_select,
  );


  reg[:] current_state, next_state;
