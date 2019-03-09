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
  input[3:0] zero_reg,
  input[1:0] write
  );

  wire[31:0] v_Y1, v_Y2;
  reg[31:0] v_A;
  reg[31:0] v_B;
  reg[31:0] v_C;
  reg[31:0] v_D;

  reg[31:0] registers[15:0];

  always @(*) begin
    if(zero_reg[0]) begin
      v_A = 0; end
    else begin
      v_A = registers[A]; end
    if(zero_reg[1]) begin
      v_A = 0; end
    else begin
      v_A = registers[B]; end
    if(zero_reg[2]) begin
      v_A = 0; end
    else begin
      v_A = registers[C]; end
    if(zero_reg[3]) begin
      v_A = 0; end
    else begin
      v_A = registers[D]; end
  end

  ALU alu(
    .op(op), .form(form), .vec(vec),
    .A(v_A), .B(v_B), .C(v_C), .D(v_D), .Y1(v_Y1), .Y2(v_Y2));

  always @(posedge clk) begin
    if(write[0]) begin
      registers[Y1] <= v_Y1;
    end
    if(write[1]) begin
      registers[Y2] <= v_Y2;
    end
  end
endmodule
