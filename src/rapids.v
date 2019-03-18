module rapids(clk, instruction);
  input[31:0] instruction;

  wire program_counter_inc;
  wire[2:0] alu_op;
  wire[1:0] alu_vec_perci;
  wire alu_form;
  wire const_c;
  wire[31:0] constant;
  wire[3:0] zero_reg;
  wire[3:0] alu_a_select;
  wire[3:0] alu_b_select;
  wire[3:0] alu_c_select;
  wire[3:0] alu_d_select;
  wire[3:0] alu_Y1_select;
  wire[3:0] alu_Y2_select;
  wire[1:0] alu_write;
  wire copy_neg;
  wire[3:0] copy_select;



  controlpath C(
    .clk(clk),
    .instruction(instruction),
    .program_counter_inc(program_counter_inc),
    .alu_op(alu_op),
    .alu_form(alu_form),
    .alu_vec_perci(alu_vec_perci),
    .const_c(const_c),
    .zero_reg(zero_reg),
    .alu_a_select(alu_a_select),
    .alu_b_select(alu_b_select),
    .alu_c_select(alu_c_select),
    .alu_d_select(alu_d_select),
    .alu_Y1_select(alu_Y1_select),
    .alu_Y2_select(alu_Y2_select),
    .alu_write(alu_write)
    .copy_neg(copy_neg),
    .copy_select(copy_select)
    );

  datapath datapath(
    .clk(clk),
    .op(alu_op),
    .form(alu_form),
    .vec(alu_vec_perci),
    .A(alu_a_select),
    .B(alu_b_select),
    .C(alu_c_select),
    .D(alu_d_select),
    .zero_reg(zero_reg),
    .Y1(alu_Y1_select),
    .Y2(alu_Y2_select),
    .write(alu_write),
    .const_c(const_c),
    .program_counter_inc(program_counter_inc),
    .constant(constant),
    .copy_neg(copy_neg),
    .copy_select(copy_select)
    );
