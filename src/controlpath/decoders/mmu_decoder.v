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
  output sl_condition,
  output reg[1:0] write
  );
  assign {st, ld, reg_addr, mem_loca_addr, sl_select} = instruction[29:16];
  assign {sl_op, sl_neg, sl_const_c, sl_condition} = 6'b111000;
  always @(*) begin
    if(ld)
      write = 2'b01;
    else
      write = 2'b00;
  end

  assign invalid_instruction = ~(st | ld);

endmodule
