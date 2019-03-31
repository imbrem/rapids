module comparetor(
  output[7:0] res,
  input[31:0] V1,
  input[31:0] V2
  );
  localparam
    ALWAYS = 3'd0,
    EQ = 3'd1,
    NEQ = 3'd2,
    LT = 3'd3,
    LEQ = 3'd4,
    ZERO = 3'd5,
    NZ = 3'd6,
    LZ = 3'd7;

  assign res[0] = 1;
  assign res[1] = V1 == V2;
  assign res[2] = V1 != V2;
  assign res[3] = V1 < V2;
  assign res[4] = V1 < V2 | V1 == V2;
  assign res[5] = (V1 == 0) & (V2 == 0);
  assign res[6] = (V1 != 0) & (V2 != 0);
  assign res[7] = V1[31] & V2[31];
endmodule
