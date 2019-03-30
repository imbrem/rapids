module basic_controlpath_test;
  reg err;

  reg clk;
  reg[31:0] instruction;
  reg instr_segv, data_segv;
  reg wait_data, wait_instr;
  wire pc_inc;
  wire[2:0] opcode;
  wire alu_form;
  wire[1:0] alu_vec_perci;
  wire[3:0] alu_config;
  wire const_c;
  wire[3:0] a_select;
  wire[3:0] alu_b_select;
  wire[3:0] alu_c_select;
  wire[3:0] alu_d_select;
  wire[3:0] alu_Y1_select;
  wire[3:0] alu_Y2_select;
  wire[1:0] reg_write;
  wire[3:0] op_select;
  wire[3:0] mem_loca_addr;
  wire[3:0] reg_addr;
  wire st;
  wire ld;


  controlpath C(
    .clk(clk),
    .instruction(instruction),
    .instr_segv(instr_segv),
    .data_segv(data_segv),
    .wait_instr(wait_instr),
    .wait_data(wait_data),
    .pc_inc(pc_inc),
    .opcode(opcode),
    .alu_form(alu_form),
    .alu_config(alu_config),
    .alu_vec_perci(alu_vec_perci),
    .const_c(const_c),
    .a_select(a_select),
    .alu_b_select(alu_b_select),
    .alu_c_select(alu_c_select),
    .alu_d_select(alu_d_select),
    .alu_Y1_select(alu_Y1_select),
    .alu_Y2_select(alu_Y2_select),
    .reg_write(reg_write),
    .op_select(op_select),
    .mem_loca_addr(mem_loca_addr),
    .reg_addr(reg_addr),
    .ld(ld),
    .st(st)
    );

  initial begin
  $dumpfile("build/basic_controlpath_test.vcd");
  $dumpvars;

  err = 0;

    if (!err) begin
      $display("BASIC CONTROLPATH TEST: All good!"); end
    else begin
      $display("BASIC CONTROLPATH TEST: Had errors!"); end
  $finish;
  end
endmodule
