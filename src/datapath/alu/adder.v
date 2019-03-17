module adder (form, vec, A, B, C, D, Y1, Y2);

  input form;
  input[1:0] vec;
  input[31:0] A, B, C, D;
  output reg[31:0] Y1, Y2;

  genvar preci;
  for(preci = 0; preci < 3; preci = preci + 1) begin : precgen_add
    genvar biti;
    localparam integer nobits = (1 << (preci + 3));
    for(biti = 0; biti < 32/nobits; biti = biti + 1) begin : bitgen_add
      localparam integer lb = (biti + 1)*nobits - 1;
      localparam integer rb = biti*nobits;
      always @(*) begin
        if(vec == preci) begin

          if(!form) begin
            Y1[lb:rb] = A[lb:rb] + C[lb:rb];
            Y2[lb:rb] = B[lb:rb] + D[lb:rb];
          end
          else begin
            {Y1[lb:rb], Y2[lb:rb]} = A[lb:rb] + B[lb:rb] + C[lb:rb];
          end

        end

      end
    end
  end

  always @(*) begin
    if(vec == 2'b11) begin
      {Y1, Y2} = {A, B} + {C, D};
    end
  end


endmodule
