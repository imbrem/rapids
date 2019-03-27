module datapath(
  input clk,
  input[2:0] alu_op,
  input form,
  input[1:0] vec,
  input[3:0] alu_config,
  input[3:0] A,
  input[3:0] B,
  input[3:0] C,
  input[3:0] D,
  input[3:0] Y1, Y2,
  input[1:0] write,
  input const_c,
  input pc_inc,
  input[31:0] constant,
  input[3:0] logic_select,
  input[31:0] mem_data,
  output[31:0] program_counter
);

  wire[31:0] v_Y1, v_Y2;
  wire[31:0] constant;
  wire[31:0] v_A;
  wire[31:0] v_B;
  reg[31:0] v_C;
  wire[31:0] v_D;

  reg[31:0] registers[15:0];
  wire[31:0] register_view[15:0];

  genvar i;
  assign register_view[0] = pc_inc ? 32'b0 : registers[0];
  for(i = 1; i < 16; i = i + 1) begin : register_view_assignment
    assign register_view[i] = registers[i];
  end

  assign program_counter = registers[0];
  assign v_A = register_view[A];
  assign v_B = register_view[B];
  always @(*) begin
    if(const_c)
      v_C = constant;
    else
      v_C = register_view[C];
  end
  assign v_D = register_view[D];
  assign w_Y1 = write[0] & ~(pc_inc & (Y1 == 0));
  assign w_Y2 = write[1] & ~(pc_inc & (Y2 == 0));

  ALU alu(
    .op(alu_op), .form(form), .vec(vec),
    .A(v_A), .B(v_B), .C(v_C), .D(v_D), .Y1(v_Y1), .Y2(v_Y2),
    .logic_select(logic_select));

  always @(posedge clk) begin
    if(w_Y1) begin
      registers[Y1] <= v_Y1;
    end
    if(w_Y2) begin
      registers[Y2] <= v_Y2;
    end
    if(pc_inc) begin
      registers[0] += 1;
    end
  end
endmodule
