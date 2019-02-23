// The ALU for the Rapids microprocessor.
// Operations:
// Shared between FPU and integers:
// 000: ADD
// 100: SUB
// 010: MUL
// 110: FMA
// Split between FPU and integers:
// 001: SHL or Floating * 2^n
// 011: SHR or Floating * 2^(-n)
// FPU bit triggers other integer operation
// 101: (AND or NAND) or (HAND or HOR)
// 110: (OR or NOR) or (XOR or XNOR)

// Semantics:
// ADD:
//  <=FULL: Y1 = A + C, Y2 = B + D OR (Y1, Y2) = A + B + C
//  DOUBLE: (Y1, Y2) = (A, B) + (C, D)
// SUB
//  <=FULL: Y1 = A - C, Y2 = B - D OR (Y1, Y2) = A - C - B
//  DOUBLE: (Y1, Y2) = (A, B) - (C, D)
// MUL:
//  <=FULL: Y1 = A * C, Y2 = B * D OR (Y1, Y2) = A * B * C
//  DOUBLE: (Y1, Y2) = (A, B) * (C, D)
// FMA:
//  <=FULL: (Y1, Y2) = (A*B) + C
//  DOUBLE: (Y1, Y2) = (A, B) * (C, D) + (C, D)
// SHL: (Y1, Y2) = (A, B) << (C - D) (zero/barrel)
// SHR: (Y1, Y2) = (A, B) >> (C - D) (zero/barrel)
// AND: (Y1, Y2) = (A, B) (AND/NAND) (C, D)
// OR: (Y1, Y2) = (A, B) (OR/NOR) (C, D)
// XOR: (Y1, Y2) = (A, B) (XOR/XNOR) (C, D)
// HAND: Y1 = (A HAND B), Y2 = (C HAND D)
// HOR: Y1 = (A HOR B), Y2 = (C HOR D)

module ALU(op, floating, form, precision, A, B, C, D, Y1, Y2);
  input[2:0] op; // The base operation
  input floating; // Whether to use floating point arithmetic
  input form; // Whether to, if applicable, use the first or second form of an op
  input[1:0] precision; // How much precision to use: CHAR, HALF, FULL, DOUBLE
  input[31:0] A, B, C, D; // Input registers
  output reg[31:0] Y1, Y2; // Output registers

  genvar gi;

  always @(*) begin
    {Y1, Y2} = {A, B}; //TODO: implement
  end

endmodule
