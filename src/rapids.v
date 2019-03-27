module rapids(clk);
  input clk;

  wire[31:0] instruction;

  wire pc_inc;
  wire[2:0] alu_op;
  wire[1:0] alu_vec_perci;
  wire alu_form;
  wire[3:0] alu_config;
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
  wire[3:0] logic_select;
  wire[31:0] program_counter;

  wire[31:0] mem_data;
  wire instr_segv;
  wire data_segv;
  wire wait_instr;
  wire wait_data;

  controlpath C(
    .clk(clk),
    .instruction(instruction),
    .instr_segv(instr_segv),
    .data_segv(data_segv),
    .wait_instr(wait_instr),
    .wait_data(wait_data),
    .pc_inc(pc_inc),
    .alu_op(alu_op),
    .alu_form(alu_form),
    .alu_vec_perci(alu_vec_perci),
    .alu_config(alu_config),
    .const_c(const_c),
    .alu_a_select(alu_a_select),
    .alu_b_select(alu_b_select),
    .alu_c_select(alu_c_select),
    .alu_d_select(alu_d_select),
    .alu_Y1_select(alu_Y1_select),
    .alu_Y2_select(alu_Y2_select),
    .alu_write(alu_write),
    .logic_select(logic_select)
    );

  datapath D(
    .clk(clk),
    .alu_op(alu_op),
    .form(alu_form),
    .vec(alu_vec_perci),
    .alu_config(alu_config),
    .A(alu_a_select),
    .B(alu_b_select),
    .C(alu_c_select),
    .D(alu_d_select),
    .Y1(alu_Y1_select),
    .Y2(alu_Y2_select),
    .write(alu_write),
    .const_c(const_c),
    .pc_inc(pc_inc),
    .constant(constant),
    .logic_select(logic_select),
    .mem_data(mem_data),
    .program_counter(program_counter)
    );

  MMU mmu(
    .clk(clk),
    .instr_addr(program_counter),
    .data_addr(0),
    .data_in(0),
    .rd(1'b0),
    .wd(1'b0),
    .instr(instruction),
    .data(mem_data),
    .wait_instr(wait_instr),
    .wait_data(wait_data),
    .instr_segv(instr_segv),
    .data_segv(data_segv)
    );

endmodule
