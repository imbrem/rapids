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
  input[1:0] write,
  input const_c,
  input pc_inc,
  input[31:0] constant,
  input[3:0] copy_select
);

  wire[31:0] v_Y1, v_Y2;
  wire[31:0] constant;
  reg[31:0] v_A;
  reg[31:0] v_B;
  reg[31:0] v_C;
  reg[31:0] v_D;

  reg[31:0] registers[15:0];

  always @(*) begin
    if(A == 4'b0 & pc_inc) begin
      v_A = 0; end
    else begin
      v_A = registers[A]; end
    if(B == 4'b0 & pc_inc) begin
      v_B = 0; end
    else begin
      v_B = registers[B]; end
    if(C == 4'b0 & pc_inc) begin
      v_C = 0; end
    else if(const_c) begin
      v_C = constant; end
    else begin
      v_C = registers[C]; end
    if(D == 4'b0 & pc_inc) begin
      v_D = 0; end
    else begin
      v_D = registers[D]; end
  end

  ALU alu(
    .op(op), .form(form), .vec(vec),
    .A(v_A), .B(v_B), .C(v_C), .D(v_D), .Y1(v_Y1), .Y2(v_Y2),
    .copy_select(copy_select));

  always @(posedge clk) begin
    if(write[0]) begin
      registers[Y1] <= v_Y1;
    end
    if(write[1]) begin
      registers[Y2] <= v_Y2;
    end
  end
endmodule
