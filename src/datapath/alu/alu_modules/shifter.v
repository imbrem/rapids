module shifter(
  input shift_add,
  input[31:0] A,
  input[31:0] B,
  input[31:0] C,
  input[31:0] D,
  input left,
  input asr,
  output reg[31:0] Y1,
  output reg[31:0] Y2
  );

  always @(*) begin
    case({shift_add, asr, left})
      3'b000: {Y1, Y2} = {A >> C, B >> D};
      3'b001: {Y1, Y2} = {A << C, B << D};
      3'b010: {Y1, Y2} = {A >>> C, B >>> D};
      3'b011: {Y1, Y2} = {A <<< C, B <<< D};
      3'b100: {Y1, Y2} = {A >> B + C, 32'b0};
      3'b101: {Y1, Y2} = {A << B + C, 32'b0};
      3'b110: {Y1, Y2} = {A >>> B + C, 32'b0};
      3'b111: {Y1, Y2} = {A <<< B + C, 32'b0};
    endcase
  end

endmodule
