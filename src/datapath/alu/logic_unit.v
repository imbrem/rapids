module logic_unit(
  input logic_neg,
  input[3:0] logic_select,
  input[2:0] logic_op,
  input[31:0] A,
  input[31:0] B,
  input[31:0] C,
  input[31:0] D,
  output reg[31:0] Y1,
  output reg[31:0] Y2
  );

  localparam
    AND = 3'b010,
    OR = 3'b011,
    XOR = 3'b110,
    COPY = 3'b111;

  genvar i;
  for(i = 0; i < 4; i = i + 1) begin: partition_loop
    localparam  rb = 8*i, lb = 8*i+7;
    always @(*) begin
      if(logic_select[i]) begin
        case(logic_op)
          AND: begin
            {Y1[lb:rb], Y2[lb:rb]} =
            logic_neg ? {A[lb:rb] & C[lb:rb], B[lb:rb] & D[lb:rb]} : {A[lb:rb] & C[lb:rb], B[lb:rb] & D[lb:rb]};
          end
          OR: begin
            {Y1[lb:rb], Y2[lb:rb]} =
            logic_neg ? {A[lb:rb] | C[lb:rb], B[lb:rb] | D[lb:rb]} : {A[lb:rb] | C[lb:rb], B[lb:rb] | D[lb:rb]};
          end
          XOR: begin
            {Y1[lb:rb], Y2[lb:rb]} =
            logic_neg ? {A[lb:rb] ^ C[lb:rb], B[lb:rb] ^ D[lb:rb]} : {A[lb:rb] ^ C[lb:rb], B[lb:rb] ^ D[lb:rb]};
          end
          COPY: begin
            {Y1[lb:rb], Y2[lb:rb]} = logic_neg ? ~{C[lb:rb], D[lb:rb]} : {C[lb:rb], D[lb:rb]};
          end
          default: begin
            {Y1[lb:rb], Y2[lb:rb]} = 64'b0;
          end
        endcase
      end
      else begin
        {Y1[lb:rb], Y2[lb:rb]} = 32'b0;
      end
    end
  end

endmodule
