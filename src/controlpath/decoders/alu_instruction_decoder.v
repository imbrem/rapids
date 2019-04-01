module alu_instruction_decoder (
  input[31:0] instruction,
  output reg invalid_instruction,
  output reg[2:0] alu_op,
  output reg[1:0] alu_vec_perci,
  output reg alu_form,
  output reg const_c,
  output reg[31:0] constant,
  output reg[3:0] alu_a_select,
  output reg[3:0] alu_b_select,
  output reg[3:0] alu_c_select,
  output reg[3:0] alu_d_select,
  output reg[3:0] alu_Y1_select,
  output reg[3:0] alu_Y2_select,
  output reg[1:0] alu_write,
  output reg[3:0] logic_select,
  output reg condition,
  output reg [2:0] compare_op
  );

  localparam
    ADD = 3'b000,
    SUB = 3'b100,
    SR = 3'b001,
    SL= 3'b101,
    AND = 3'b010,
    OR = 3'b011,
    XOR = 3'b110,
    COPY = 3'b111;

  always @(*) begin
    //General assignments
    {const_c, alu_op, alu_form, alu_vec_perci} = instruction[28:22];
    {condition, compare_op} = instruction[19:16];
    {alu_a_select, alu_b_select, alu_c_select, alu_d_select} = instruction[15:0];
    alu_write = 2'b11;
    constant = {16'b0, instruction[15:0]};
    logic_select = instruction[23:20];


    if(const_c) begin
      alu_write = 2'b01;
      if(alu_op == SR | alu_op == SL)
        constant = instruction[7:0];
      else
        alu_a_select = instruction[19:16];
    end

    //Make sure to not write to register 0
    {alu_Y1_select, alu_Y2_select} = {alu_a_select, alu_b_select};
    if(~condition) begin
      if(alu_Y1_select == 4'b0) begin
        alu_write[0] = 0; end
      if(alu_Y2_select == 4'b0) begin
        alu_write[1] = 0; end
    end
    else begin alu_write = 2'b01; end

    invalid_instruction = condition & const_c;
  end
endmodule
