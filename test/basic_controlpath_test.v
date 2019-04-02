module basic_controlpath_test;
  reg err;

  reg clk;
  reg go;
  reg reset_n;
  reg[31:0] instruction;
  reg instr_segv, data_segv;
  reg wait_data, wait_instr;
  wire pc_inc;
  wire[2:0] opcode;
  wire form;
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
  wire st;
  wire ld;


  controlpath C(
    .clk(clk),
    .go(go),
    .reset_n(reset_n),
    .instruction(instruction),
    .instr_segv(instr_segv),
    .data_segv(data_segv),
    .wait_instr(wait_instr),
    .wait_data(wait_data),
    .pc_inc(pc_inc),
    .opcode(opcode),
    .form(form),
    .alu_config(alu_config),
    .alu_vec_perci(alu_vec_perci),
    .const_c(const_c),
    .a_select(a_select),
    .alu_b_select(alu_b_select),
    .alu_c_select(alu_c_select),
    .alu_d_select(alu_d_select),
    .Y1_select(alu_Y1_select),
    .alu_Y2_select(alu_Y2_select),
    .reg_write(reg_write),
    .op_select(op_select),
    .mem_loca_addr(mem_loca_addr),
    .ld(ld),
    .st(st)
    );

  always begin
    clk = 1'b0; #1; clk = 1'b1; #1;
  end

  localparam
    HALT = 5'b00000,
    READ_INS = 5'b01000,
    WAIT_LOAD = 5'b01010,
    WAIT_STORE = 5'b01100,
    DO = 5'b01001,
    TRAP = 5'b10000;

  initial begin
    $dumpfile("build/basic_controlpath_test.vcd");
    $dumpvars;
    err = 0;

    reset_n = 0;
    #2;
    reset_n = 1;
    #2;
    go = 0;
    reset_n = 0;
    instruction = 32'h80801234;
    data_segv = 0;
    instr_segv = 0;
    wait_data = 0;
    wait_instr = 1;
    #4
    if(C.current_state != HALT) begin
      $display(
        "CONTROLPATH TEST: initial condition test failed, got %d",
        C.current_state
        );
      err = 1;
    end

    go = 1;
    #2
    if(C.current_state != READ_INS) begin
      $display(
        "CONTROLPATH TEST: read instruction loop test failed, got %d",
        C.current_state
        );
      err = 1;
    end

    wait_instr = 0;
    #2
    if(
      C.current_state != DO |
      a_select != 1 |
      reg_write != 2'b11 |
      const_c != 0
      ) begin
      $display(
        "CONTROLPATH TEST: looping test failed, got %d",
        C.current_state
        );
      err = 1;
    end

    if (!err) begin
      $display("BASIC CONTROLPATH TEST: All good!"); end
    else begin
      $display("BASIC CONTROLPATH TEST: Had errors!"); end
  $finish;
  end
endmodule
