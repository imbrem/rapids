module logic_unit_test;
  reg err;

  reg neg;
  reg[3:0] select;
  reg[2:0] op;
  reg[31:0] A;
  reg[31:0] B;
  reg[31:0] C;
  reg[31:0] D;
  wire[31:0] Y1;
  wire[31:0] Y2;

  localparam
    ADD = 3'b000,
    SUB = 3'b100,
    MULT = 3'b001,
    DIV = 3'b101,
    AND = 3'b010,
    OR = 3'b011,
    XOR = 3'b110,
    COPY = 3'b111;

  logic_unit logic_unit (
    .logic_neg(neg), .logic_select(select), .logic_op(op),
    .A(A), .B(B), .C(C), .D(D), .Y1(Y1), .Y2(Y2)
    );
  initial begin;
    $dumpfile("build/logic_unit_test.vcd");
    $dumpvars;
    err = 0;

    neg = 0;
    select = 0;
    op = 0;
    A = 0;
    B = 0;
    C = 0;
    D = 0;

    //Try copy without neg
    select = 4'b0001;
    op = COPY;
    C = 32'h00000010;
    #2
    if(Y1 != 32'd16) begin
      $display(
        "LOGIC UNIT TEST: copy lower 8-bits failed, invalid result %d (expected 16)",
        Y1
      );
      err = 1;
    end

    //Try and without neg
    select = 4'b0001;
    op = AND;
    A = 32'h000000FF;
    C = 32'h00000010;
    #2
    if(Y1 != 32'd16) begin
      $display(
        "LOGIC UNIT TEST: and lower 8-bits failed, invalid result %d (expected 16)",
        Y1
      );
      err = 1;
    end

    neg = 1;
    op = COPY;
    #2;
    if(Y1 != 32'd239) begin
      $display(
        "LOGIC UNIT TEST: and lower 8-bits failed, invalid result %d (expected d239)",
        Y1
      );
      err = 1;
    end

    if (!err) begin
      $display("LOGIC UNIT TEST: All good!"); end
    else begin
      $display("LOGIC UNIT TEST: Had errors!"); end
    $finish;
  end
endmodule
