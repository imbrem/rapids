module datapath(
  input clk,
  input[2:0] op,
  input form,
  input[1:0] vec,
  input[3:0] A,
  input[3:0] B,
  input[3:0] C,
  input[3:0] D,
  input[3:0] Y1, Y2,
  input[3:0] zero_PC,
  input[1:0] write
  );

  wire[31:0] v_Y1, v_Y2;
  wire[31:0] v_A = registers[A];
  wire[31:0] v_B = registers[B];
  wire[31:0] v_C = registers[C];
  wire[31:0] v_D = registers[D];

  reg[31:0] registers[15:0];

  ALU alu(
    .op(op), .form(form), .vec(vec),
    .A(v_A), .B(v_B), .C(v_C), .D(v_D), .Y1(v_Y1), .Y2(v_Y2));

endmodule
