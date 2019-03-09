module datapath(
  input[2:0] op,
  input form,
  input[1:0] vec
  );

  wire[31:0] Y1, Y2;
  wire[31:0] A = 0;
  wire[31:0] B = 0;
  wire[31:0] C = 0;
  wire[31:0] D = 0;

  ALU alu(
    .op(op), .form(form), .vec(vec),
    .A(A), .B(B), .C(C), .D(D), .Y1(Y1), .Y2(Y2));

endmodule
