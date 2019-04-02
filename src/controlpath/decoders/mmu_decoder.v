module mmu_decoder(
  input[29:0] instruction,
  output invalid_instruction,
  output[3:0] reg_addr,
  output[3:0] mem_loca_addr,
  output st,
  output ld,
  output[3:0] sl_select,
  output[2:0] sl_op,
  output reg[1:0] write
  );
  assign {st, ld, reg_addr, mem_loca_addr, st_select} = instruction[29:16];
  assign sl_op = 3'b111;
  always @(*) begin
    if(ld)
      write = 2'b10;
    else if(st)
      write = 2'b00;
  end

  assign invalid_instruction = ~(st | ld);

endmodule