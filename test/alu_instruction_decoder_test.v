module alu_instruction_decoder_test;
  reg err;

  reg[31:0] instruction;
  wire invalid_instruction;
  wire [2:0] alu_op;
  wire [1:0] alu_vec_perci;
  wire alu_from;
  wire const_c;
  wire[31:0] constant;
  wire[1:0] alu_write;
  wire[3:0] zero_reg;
  wire[3:0] alu_a_select;
  wire[3:0] alu_b_select;
  wire[3:0] alu_c_select;
  wire[3:0] alu_d_select;
  wire[3:0] alu_Y1_select;
  wire[3:0] alu_Y2_select;

  alu_instruction_decoder d(
    .instruction(instruction),
    .invalid_instruction(invalid_instruction),
    .alu_op(alu_op),
    .alu_vec_perci(alu_vec_perci),
    .alu_form(alu_form),
    .const_c(const_c),
    .constant(constant),
    .zero_reg(zero_reg),
    .alu_a_select(alu_a_select),
    .alu_b_select(alu_b_select),
    .alu_c_select(alu_c_select),
    .alu_d_select(alu_d_select),
    .alu_Y1_select(alu_Y1_select),
    .alu_Y2_select(alu_Y2_select),
    .alu_write(alu_write)
    );

  initial begin
    $dumpfile("build/alu_instruction_decoder_test.vcd");
    $dumpvars;

    err = 0;

    //Try no vector Addition form 4
    instruction = 32'h00801234;
    #1;
    if(
        alu_op != 3'b000 |
        alu_vec_perci != 2'b10 |
        alu_form != 0 |
        const_c != 0 |
        constant != 32'b0 |
        alu_write != 2'b11 |
        zero_reg != 4'b0000 |
        alu_a_select != 4'h1 |
        alu_b_select != 4'h2 |
        alu_c_select != 4'h3 |
        alu_d_select != 4'h4 |
        alu_Y1_select != 4'h1 |
        alu_Y2_select != 4'h3
      )begin
        $display("ALU INSTRUCTION DECODER TEST: none-vector addition 4 form test failed, got ");
        err = 1;
    end

    //Try constant operation 256
    instruction = 32'h10801800;
    #1;
    if(
        alu_op != 3'b000 |
        alu_vec_perci != 2'b10 |
        alu_form != 0 |
        const_c != 1 |
        constant != 32'd2048 |
        alu_write != 2'b01 |
        alu_a_select != 4'h1 |
        alu_b_select != 4'h8 |
        alu_c_select != 4'h0 |
        alu_d_select != 4'h0 |
        alu_Y1_select != 4'h1 |
        alu_Y2_select != 4'h0
      )begin
        $display("ALU INSTRUCTION DECODER TEST: none-vector constant addition 4 form test failed, got %d", constant);
        err = 1;
    end


    if (!err) begin
      $display("ALU INSTRUCTION DECODER TEST: All good!"); end
    else begin
      $display("ALU INSTRUCTION DECODER TEST: Had errors!"); end
    $finish;
  end
endmodule
