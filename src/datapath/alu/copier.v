module copier (copy_neg, copy_select, A, B, C, D, Y1, Y2);

  input[31:0] A, B, C, D;
  input copy_neg;
  input[3:0] copy_select;
  output reg [31:0] Y1, Y2;

  always@(*) begin
    if(copy_select[0]) begin
      Y1[7:0] = copy_neg ? ~C[7:0] : C[7:0];
      Y2[7:0] = copy_neg ? ~D[7:0] : D[7:0];
      end
    else begin
      Y1[7:0] = 8'b0;
      Y2[7:0] = 8'b0;
      end

    if(copy_select[1]) begin
      Y1[15:8] = copy_neg ? ~C[15:8] : C[15:8];
      Y2[15:8] = copy_neg ? ~D[15:8] : D[15:8];
      end
    else begin
      Y1[15:8] = 8'b0;
      Y2[15:8] = 8'b0;
      end

    if(copy_select[2]) begin
      Y1[23:16] = copy_neg ? ~C[23:16] : C[23:16];
      Y2[23:16] = copy_neg ? ~D[23:16] : D[23:16];
      end
    else begin
      Y1[23:16] = 8'b0;
      Y2[23:16] = 8'b0;
      end

    if(copy_select[3]) begin
      Y1[31:24] = copy_neg ? ~C[31:24] : C[31:24];
      Y2[31:24] = copy_neg ? ~D[31:24] : D[31:24];
      end
    else begin
      Y1[31:24] = 8'b0;
      Y2[31:24] = 8'b0;
      end
  end
endmodule
