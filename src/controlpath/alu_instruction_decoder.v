module alu_instruction_decoder (
  input[31:0] instruction,
  output reg invalid_instruction,
  output reg[2:0] alu_op,
  output reg[1:0] alu_vec_perci,
  output reg alu_form,
  output reg[3:0] alu_config,
  output reg const_c,
  output reg[31:0] constant,
  output reg[3:0] alu_a_select,
  output reg[3:0] alu_b_select,
  output reg[3:0] alu_c_select,
  output reg[3:0] alu_d_select,
  output reg[3:0] alu_Y1_select,
  output reg[3:0] alu_Y2_select,
  output reg[1:0] alu_write,
  output reg[3:0] copy_select
  );

  always @(*) begin
    //General assignments
    {const_c, alu_op, alu_form, alu_vec_perci} = instruction[28:22];
    alu_config = instruction[19:16];
    {alu_a_select, alu_b_select, alu_c_select, alu_d_select} = instruction[15:0];
    alu_write = 2'b00;
    constant = {16'b0, instruction[15:0]};
    copy_select = 4'b0000;

    //This assumes that constant bit can be used for something else
    if(alu_op == 3'b000 | alu_op == 3'b100) begin //case addition and subtraction
      if (const_c) begin
        alu_a_select = alu_config;
        {alu_b_select, alu_d_select} = 0;
      end
    end//end case addition and subtraction

    else if(alu_op == 3'b010) begin //case copy
      copy_select = instruction[23:20];
    end //case copy

    //Make sure to not write to register 0
    {alu_Y1_select, alu_Y2_select} = {alu_a_select, alu_c_select};
    if(alu_Y1_select != 4'b0) begin
      alu_write[0] = 1; end
    if(alu_Y2_select != 4'b0) begin
      alu_write[1] = 1; end

  end
endmodule
