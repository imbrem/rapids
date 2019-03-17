module copier (copy_neg, copy_select, A, B, C, D, Y1, Y2);

  input[31:0] A, B, C, D;
  input copy_neg;
  input[3:0] copy_select;
  output reg [31:0] Y1, Y2;

  always@(*) begin
    if(copy_select[0]) begin
      Y1[7:0] = copy_neg ? ~A[7:0] : A[7:0];  end
    else begin
      Y1[7:0] = 8'b0; end
    if(copy_select[1]) begin
      Y1[15:8] = copy_neg ? ~A[15:8] : A[15:8]; end
    else begin
      Y1[15:8] = 8'b0; end
    if(copy_select[2]) begin
      Y1[23:16] = copy_neg ? ~A[23:16] : A[23:16]; end
    else begin
      Y1[23:16] = 8'b0; end
    if(copy_select[3]) begin
      Y1[31:24] = copy_neg ? ~A[31:24] : A[31:24]; end
    else begin
      Y1[31:24] = 8'b0; end
  end
endmodule
