`define initial_addr 32'd16

module datapath(
  input clk,
  input pc_inc,
  input reset_n,
  input jump,
  //alu
  input[2:0] alu_op,
  input form,
  input[1:0] vec,
  input[3:0] A,
  input[3:0] B,
  input[3:0] C,
  input[3:0] D,
  input[3:0] Y1, Y2,
  input[1:0] write,
  input const_c,
  input[31:0] constant,
  input[3:0] logic_select,
  //condition
  input condition,
  input[2:0] compare_op,
  //load and store
  input[3:0] mem_loca_addr,
  input ld,
  input[31:0] ld_data,
  output[31:0] st_data,
  output[31:0] mem_loca,
  //the program counter
  output[31:0] program_counter
);

  wire[31:0] v_Y1, v_Y2;
  wire[31:0] v_A;
  wire[31:0] v_B;
  reg[31:0] v_C;
  wire[31:0] v_D;
  reg w_Y1, w_Y2;
  wire[7:0] compare_res;

  reg[31:0] registers[15:0];
  wire[31:0] register_view[15:0];

  assign st_data = register_view[A];

	generate
  genvar i;
  assign register_view[0] = jump ? registers[0] : 32'b0;
  for(i = 1; i < 16; i = i + 1) begin : register_view_assignment
    assign register_view[i] = registers[i];
  end

	endgenerate
	
  assign program_counter = registers[0];
  assign v_A = register_view[A];
  assign v_B = register_view[B];
  assign v_D = register_view[D];
  always @(*) begin
    if(const_c)
      v_C = constant;
    else if(ld)
      v_C = ld_data;
    else
      v_C = register_view[C];
  end
  assign mem_loca = register_view[mem_loca_addr];

  //condition
  always @(*) begin
    if(~condition) begin
      w_Y1 = write[0] & ~(pc_inc & Y1 == 0);
      w_Y2 = write[1] & ~(pc_inc & Y2 == 0);
    end else begin
      w_Y1 = write[0] & compare_res[compare_op];
      w_Y2 = 0;
    end
  end

  ALU alu(
    .op(alu_op), .form(form), .vec(vec), .shift_add(const_c),
    .A(v_A), .B(v_B), .C(v_C), .D(v_D), .Y1(v_Y1), .Y2(v_Y2),
    .logic_select(logic_select), .compare_res(compare_res));

   generate
	
		for(i = 0; i < 16; i = i + 1) begin : register_setting
			always @(posedge clk) begin
				if(reset_n) begin
					if(i != 0) registers[i] <= 0;
					else registers[i] <= `initial_addr;
				end
				else begin
					if(i == Y1) begin
						if(w_Y1) registers[i] <= v_Y1;
					end
					if(i == Y2) begin
						if(w_Y2) registers[i] <= v_Y2;
					end
				end
			end
		end
	endgenerate
  

endmodule
