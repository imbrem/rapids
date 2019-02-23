module alu_test;
  reg err;

  reg[2:0] op;
  reg floating;
  reg form;
  reg[1:0] precision;
  reg[31:0] A, B, C, D;
  wire[31:0] Y1, Y2;
  ALU alu (
    .op(op),
    .floating(floating),
    .form(form),
    .precision(precision),
    .A(A), .B(B), .C(C), .D(D),
    .Y1(Y1), .Y2(Y2)
  );

  initial begin;
    err = 0;
    A = 1;
    B = 2;
    C = 3;
    D = 2;
    form = 1;
    floating = 0;
    op = 0;
    #1;
    if({Y1, Y2} != 6) begin
      $display("ALU TEST: Adder form 1 not working: invalid result!");
      err = 1;
    end
    if (!err) begin
      $display("ALU TEST: All good!"); end
    else begin
      $display("ALU TEST: Had errors!"); end
    $finish;
  end
endmodule
