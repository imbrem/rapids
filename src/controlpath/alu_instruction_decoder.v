module alu_instruction_decoder (
  input[31:0] instruction,
  output reg invalid_instruction,
  output reg[2:0] alu_op,
  output reg[1:0] alu_vec_perci,
  output reg alu_form,
  output reg const_c,
  output reg[15:0] constant,
  output reg[3:0] alu_a_select,
  output reg[3:0] alu_b_select,
  output reg[3:0] alu_c_select,
  output reg[3:0] alu_d_select,
  output reg[3:0] alu_Y1_select,
  output reg[3:0] alu_Y2_select,
  output reg[1:0] alu_write
  );

  always @(*) begin
    {const_c, alu_op, alu_form, alu_vec_perci} = instruction[28:22];
    {alu_a_select, alu_b_select, alu_c_select, alu_d_select} = instruction[15:0];
    alu_Y1_select = alu_a_select;
  end

  always @(*) begin
    if(const_c & !alu_form) begin
      alu_Y2_select = 4'b0000;
      alu_write = 2'b01;
      constant = {16'b0, instruction[19:16], instruction[11:0]};
    end
    else if(!alu_form) begin
      constant = 0;
      alu_Y2_select = alu_c_select;
      if(alu_Y1_select == 4'b0)
        alu_write[0] = 0;
      else
        alu_write[0] = 1;
      if(alu_Y2_select == 4'b0)
        alu_write[1] = 0;
      else
        alu_write[0] = 1;
    end
    else if(alu_form & !const_c) begin
      constant = 0;
      alu_Y2_select = alu_b_select;
    end
    else begin
      invalid_instruction = 1;
    end
  end
endmodule
