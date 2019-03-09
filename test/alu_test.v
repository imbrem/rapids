module alu_test;
  reg err;

  reg[2:0] op;
  reg form;
  reg[1:0] vec;
  reg[31:0] A, B, C, D;
  wire[31:0] Y1, Y2;
  ALU alu (
    .op(op),
    .form(form),
    .vec(vec),
    .A(A), .B(B), .C(C), .D(D),
    .Y1(Y1), .Y2(Y2)
  );

  initial begin;
    $dumpfile("build/alu_test.vcd");
    $dumpvars;

    err = 0;

    // Try 1 + 2 + 3 = 6
    A = 1;
    B = 2;
    C = 3;
    D = 2;
    form = 1;
    vec = 2;
    op = 0;
    #1;
    if({Y1, Y2} != 6) begin
      $display(
        "ALU TEST: Addition form 1 not working: invalid result %d (expected 6)",
        {Y1, Y2}
      );
      err = 1;
    end

    // Try 1 - 2 - 3 = -4
    op = 4;
    #1;
    if({Y1, Y2} != -4) begin
      $display(
        "ALU TEST: Subtraction form 1 not working: invalid result %d (expected -4)",
        {Y1, Y2}
      );
      err = 1;
    end

    if (!err) begin
      $display("ALU TEST: All good!"); end
    else begin
      $display("ALU TEST: Had errors!"); end
    $finish;
  end
endmodule
