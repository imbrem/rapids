module alu_test;
  reg err;

  reg[2:0] op;
  reg form;
  reg[1:0] vec;
  reg[31:0] A, B, C, D;
  wire[31:0] Y1, Y2;
  reg copy_neg;
  reg[3:0] copy_select;

  ALU alu (
    .op(op),
    .form(form),
    .vec(vec),
    .A(A), .B(B), .C(C), .D(D),
    .Y1(Y1), .Y2(Y2),
    .copy_neg(copy_neg), .copy_select(copy_select)
  );

  initial begin
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
    copy_neg = 0;
    copy_select = 4'b0;
    #1;
    if({Y1, Y2} != 6) begin
      $display(
        "ALU TEST: Addition form 1 not working: invalid result %d (expected 6)",
        {Y1, Y2}
      );
      err = 1;
    end

    // Try 1 + 3, 2 + 2
    form = 0;
    #1;
    if(Y1 != 4 | Y2 != 4) begin
      $display(
        "ALU TEST: Addition form 0 not working: invalid reslult %d (expected 4 and 4)",
        {Y1, Y2}
      );
      err = 1;
    end

    //Try {1,2} + {3,2}
    vec = 3;
    #1;
    if({Y1, Y2} != {32'h4, 32'h4}) begin
      $display(
        "ALU TEST: Vector addition form 3 not working: invalid result %d (expected {4, 4})",
        {Y1, Y2}
      );
      err = 1;
    end

    //Try Y1 = {A[31:16] + C[31:16], A[15:0] = C[15:0]}
    vec = 1;
    #1
    if({Y1, Y2} != {32'h4, 32'h4}) begin
      $display(
        "ALU TEST: Vector addition form 1 not working: invalid result %d (expected {4, 4})",
        {Y1, Y2}
      );
      err =1;
    end

    // Try 1 - 2 - 3 = -4
    vec = 2;
    form = 1;
    op = 4;
    #1;
    if({Y1, Y2} != -4) begin
      $display(
        "ALU TEST: Subtraction form 1 not working: invalid result %d (expected -4)",
        {Y1, Y2}
      );
      err = 1;
    end

    //Try 1-3, 2-2
    form = 0;
    #1;
    if(Y1 != -2 | Y2 != 0) begin
      $display(
        "ALU TEST: Subtraction form 0 not working: invalid result %d (expected -2 and 0)",
        {Y1, Y2}
      );
      err = 1;
    end

    //Try copy 1 with lower 8 bits negated.
    op = 3'b010;
    copy_neg = 1;
    copy_select = 4'b0001;
    #1;
    if(Y1 != 254) begin
      $display(
        "ALU TEST: Copy with lower 8 bits negated not working, invalid result %d, expected 32'd14.",
        {Y1}
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
