module alu_instruction_decoder (
  input[31:0] instruction,
  output reg invalid_instruction,
  output reg[2:0] alu_op,
  output reg[1:0] alu_vec_perci,
  output reg alu_form,
  output reg const_c,
  output reg[31:0] constant,
  output reg[3:0] zero_reg,
  output reg[3:0] alu_a_select,
  output reg[3:0] alu_b_select,
  output reg[3:0] alu_c_select,
  output reg[3:0] alu_d_select,
  output reg[3:0] alu_Y1_select,
  output reg[3:0] alu_Y2_select,
  output reg[1:0] alu_write,
  output reg copy_neg,
  output reg[3:0] copy_select
  );

  always @(*) begin
    //General assignments
    {const_c, alu_op, alu_form, alu_vec_perci} = instruction[28:22];
    {alu_a_select, alu_b_select, alu_c_select, alu_d_select} = instruction[15:0];
    {alu_Y1_select, alu_Y2_select} = {alu_a_select, alu_c_select};
    alu_write = 2'b00;
    constant = 0;
    zero_reg = 4'b0000;
    copy_neg = 0;
    copy_select = 4'b0000;

    //Make sure to not write to register 0
    if(alu_Y1_select != 4'b0) begin
      alu_write[0] = 1; end
    if(alu_Y2_select != 4'b0) begin
      alu_write[1] = 1; end

    if(alu_op == 3'b000 | alu_op == 3'b100) begin //case addition and subtraction
      if(!alu_form & const_c) begin
        zero_reg = 4'b1010;
        alu_write = 2'b01;
        constant = {14'b0, instruction[21:16], instruction[11:0]};
      end
      else if(!alu_form & !const_c) begin
        //Left empty in case needed in future development
      end
      else if(alu_form & !const_c) begin
        //Left empty in case needed in future development
      end
      else begin
        invalid_instruction = 1;
      end
    end//end case addition and subtraction

    else if(alu_op == 3'b010) begin //case copy
      copy_neg = instruction[24];
      copy_select = instruction[23:20];
    end //case copy
  end
endmodule
