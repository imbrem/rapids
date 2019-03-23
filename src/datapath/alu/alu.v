// The ALU for the Rapids microprocessor.
// Jad Elkhaleq Ghalayini, 2019

// Semantics:
// ADD:
//  <=FULL: Y1 = A + C, Y2 = B + D OR (Y1, Y2) = A + B + C
//  DOUBLE: (Y1, Y2) = (A, B) + (C, D)
// SUB
//  <=FULL: Y1 = A - C, Y2 = B - D OR (Y1, Y2) = A - C - B
//  DOUBLE: (Y1, Y2) = (A, B) - (C, D)

module ALU(op, form, vec, A, B, C, D, Y1, Y2, copy_select);
  input[2:0] op; // The base operation
  input form; // Whether to, if applicable, use the first or second form of an op
  input[1:0] vec; // How much precision to use: CHAR, HALF, FULL, DOUBLE
  input[31:0] A, B, C, D; // Input registers
  input[3:0] copy_select;
  output reg[31:0] Y1, Y2; // Output registers

  wire[31:0] add_Y1, add_Y2;
  wire[31:0] sub_Y1, sub_Y2;
  wire[31:0] copy_Y1, copy_Y2;
  adder adder (
    .form(form), .vec(vec), .A(A), .B(B), .C(C), .D(D),
    .Y1(add_Y1), .Y2(add_Y2)
  );
  subtractor subtractor (
    .form(form), .vec(vec), .A(A), .B(B), .C(C), .D(D),
    .Y1(sub_Y1), .Y2(sub_Y2)
  );
  copier copier (
    .copy_neg(form), .copy_select(copy_select), .A(A), .B(B), .C(C), .D(D),
    .Y1(copy_Y1), .Y2(copy_Y2)
    );

  always @(*) begin
    case (op)
      3'b000: begin // ADD
        {Y1, Y2} = {add_Y1, add_Y2};
      end
      3'b100: begin // SUB
        {Y1, Y2} = {sub_Y1, sub_Y2};
      end
      3'b010: begin
        {Y1, Y2} = {copy_Y1, copy_Y2};
      end
    endcase
  end

endmodule
