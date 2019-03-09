module datapath(
  input[2:0] op,
  input form,
  input[1:0] vec,
  input[4:0] A,
  input[4:0] B,
  input[4:0] C,
  input[4:0] D
  );

  wire[31:0] Y1, Y2;
  wire[31:0] v_A = 0;
  wire[31:0] v_B = 0;
  wire[31:0] v_C = 0;
  wire[31:0] v_D = 0;

  reg[31:0] registers[15:0];

  ALU alu(
    .op(op), .form(form), .vec(vec),
    .A(v_A), .B(v_B), .C(v_C), .D(v_D), .Y1(Y1), .Y2(Y2));

endmodule
