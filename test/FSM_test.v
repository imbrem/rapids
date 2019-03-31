module FSM_test;
  reg err;

  reg clk;
  reg go;
  reg halt;
  reg instr_alu;
  reg instr_pc;
  reg ld;
  reg st;
  reg wait_data;
  reg wait_instr;
  reg data_segv;
  reg instr_segv;
  reg invalid_instruction;
  wire[4:0] current_state;

  FSM FSM(
    .clk(clk),
    .go(go),
    .halt(halt),
    .instr_alu(instr_alu),
    .instr_pc(instr_pc),
    .ld(ld),
    .st(st),
    .wait_data(wait_data),
    .wait_instr(wait_instr),
    .data_segv(data_segv),
    .instr_segv(instr_segv),
    .invalid_instruction(invalid_instruction),
    .current_state(current_state)
    );

  always begin
    clk = 1'b0; #1; clk = 1'b1; #1;
  end

  initial begin;
    $dumpfile("build/FSM_test.vcd");
    $dumpvars;
    err = 0;

    go = 0;
    halt = 0;
    instr_alu = 1;
    instr_pc = 0;
    ld = 0;
    st = 0;
    wait_data = 1;
    wait_instr = 1;
    data_segv = 0;
    instr_segv = 0;
    invalid_instruction = 0;

    if (!err) begin
      $display("FSM TEST: All good!"); end
    else begin
      $display("FSM TEST: Had errors!"); end
    $finish;
  end
endmodule
