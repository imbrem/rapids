module basic_rapids_test;
  reg err;

  reg clk;
  reg go;
  reg halt;
  reg reset_n;

  rapids rapids(.clk(clk), .go(go), .halt(halt), .reset_n(reset_n));

  always begin
    clk = 1'b0; #1; clk = 1'b1; #1;
  end

  initial begin
    $dumpfile("build/basic_rapids_test.vcd");
    $dumpvars;

    err = 0;
    reset_n = 0;
    #2
    go = 0;
    halt = 0;
    reset_n = 1;
    #4;
    reset_n = 0;
    rapids.mmu.memory[0] = 32'h9EF10004;
    rapids.mmu.memory[1] = 32'h9EF20006;
    rapids.mmu.memory[2] = 32'h80801020;
    #4;
    go = 1;
    #20;

    if(rapids.D.registers[1] != 10) begin
      $display("BASIC RAPIDS TEST: basic arithemetic program test failed, expected 10 got %d",
      rapids.D.registers[1]
      );
      err = 1;
    end


    if (!err) begin
      $display("BASIC RAPIDS TEST: All good!"); end
    else begin
      $display("BASIC RAPIDS TEST: Had errors!"); end
  $finish;
  end
endmodule
