module rapids(clk, go, halt, reset_n, vga_x, vga_y, vga_color, vga_plot);
  input clk;
  input go;
  input halt;
  input reset_n;

  output[8:0] vga_x;
  output[7:0] vga_y;
  output[23:0] vga_color;
  output vga_plot;

  wire[31:0] instruction;
  wire[31:0] program_counter;

  wire pc_inc;
  wire jump;

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
  wire condition;
  wire[2:0] compare_op;
  wire[3:0] mem_loca_addr;
  wire[31:0] mem_loca;
  wire ld, st;
  wire[31:0] ld_data;
  wire[31:0] st_data;

  wire instr_segv;
  wire data_segv;
  wire wait_instr;
  wire wait_data;

  controlpath C(
    .clk(clk),
    .reset_n(reset_n),
    .pc_inc(pc_inc),
    .jump(jump),
    .go(go),
    .halt(halt),
    .instruction(instruction),
    .instr_segv(instr_segv),
    .data_segv(data_segv),
    .wait_instr(wait_instr),
    .wait_data(wait_data),
    .opcode(alu_op),
    .form(form),
    .alu_vec_perci(alu_vec_perci),
    .alu_config(alu_config),
    .const_c(const_c),
    .constant(constant),
    .a_select(alu_a_select),
    .alu_b_select(alu_b_select),
    .alu_c_select(alu_c_select),
    .alu_d_select(alu_d_select),
    .Y1_select(alu_Y1_select),
    .alu_Y2_select(alu_Y2_select),
    .reg_write(alu_write),
    .op_select(logic_select),
    .condition(condition),
    .compare_op(compare_op),
    .st(st),
    .ld(ld),
    .mem_loca_addr(mem_loca_addr)
    );

  datapath D(
    .clk(clk),
    .reset_n(reset_n),
    .pc_inc(pc_inc),
    .jump(jump),
    .alu_op(alu_op),
    .form(form),
    .vec(alu_vec_perci),
    .A(alu_a_select),
    .B(alu_b_select),
    .C(alu_c_select),
    .D(alu_d_select),
    .Y1(alu_Y1_select),
    .Y2(alu_Y2_select),
    .write(alu_write),
    .const_c(const_c),
    .constant(constant),
    .logic_select(logic_select),
    .condition(condition),
    .compare_op(compare_op),
    .mem_loca_addr(mem_loca_addr),
    .ld(ld),
    .ld_data(ld_data),
    .st_data(st_data),
    .program_counter(program_counter),
    .mem_loca(mem_loca)
    );

  MMU mmu(
    .clk(clk),
    .reset_n(reset_n),
    .instr_addr(program_counter),
    .data_addr(mem_loca),
    .data_in(st_data),
    .rd(ld),
    .wd(st),
    .instr(instruction),
    .data(ld_data),
    .wait_instr(wait_instr),
    .wait_data(wait_data),
    .instr_segv(instr_segv),
    .data_segv(data_segv),
    .vga_x(vga_x),
    .vga_y(vga_y),
    .vga_color(vga_color),
    .vga_plot(vga_plot)
    );

endmodule
