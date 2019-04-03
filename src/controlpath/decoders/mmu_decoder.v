module mmu_decoder(
  input[31:0] instruction,
  output invalid_instruction,
  output[3:0] reg_addr,
  output[3:0] mem_loca_addr,
  output st,
  output ld,
  output[3:0] sl_select,
  output sl_neg,
  output[2:0] sl_op,
  output sl_const_c,
  output [31:0]constant,
  output sl_condition,
  output reg[1:0] write
  );
  assign {st, ld, reg_addr, mem_loca_addr, sl_select, sl_const_c} = instruction[29:15];
  assign constant = {17'b0, instruction[14:0]};
  assign {sl_op, sl_neg, sl_condition} = 6'b11100;
  always @(*) begin
    if(ld)
      write = 2'b01;
    else
      write = 2'b00;
  end

  assign invalid_instruction = ~(st | ld);

endmodule
