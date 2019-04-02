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

  localparam
    HALT = 5'b00000,
    READ_INS = 5'b01000,
    WAIT_LOAD = 5'b01010,
    WAIT_STORE = 5'b01100,
    DO = 5'b01001,
    TRAP = 5'b10000;

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
    wait_data = 0;
    wait_instr = 0;
    data_segv = 0;
    instr_segv = 0;
    invalid_instruction = 0;
    #6
    if(current_state != HALT) begin
      $display(
        "FSM TEST: initial condition test failed, expected 'HALT', got %",
        current_state
        );
      err = 1;
    end

    go = 1;
    #2;
    if(current_state != READ_INS) begin
      $display(
        "FSM TEST: exiting halt test failed, expected 'READ_INS', got %",
        current_state
        );
      err = 1;
    end

    #2
    if(current_state != DO) begin
      $display(
        "FSM TEST: alu operation test failed, expected 'DO' got %",
        current_state
        );
      err = 1;
    end

    if (!err) begin
      $display("FSM TEST: All good!"); end
    else begin
      $display("FSM TEST: Had errors!"); end
    $finish;
  end
endmodule
