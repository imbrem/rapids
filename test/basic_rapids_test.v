module basic_rapids_test;
  reg err;

  reg clk;
  reg go;
  reg halt;

  rapids rapids(.clk(clk), .go(go), .halt(halt));

  always begin
    clk = 1'b0; #1; clk = 1'b1; #1;
  end

  initial begin
    $dumpfile("build/basic_rapids_test.vcd");
    $dumpvars;

    err = 0;

    go = 0;
    halt = 0;
    rapids.mmu.memory[0] = 32'h9E010004;
    rapids.mmu.memory[1] = 32'h9E020006;
    rapids.mmu.memory[2] = 32'h80801020;
    rapids.D.registers[0] = 32'd16;
    #10;
    go = 1;
    #10;


    if (!err) begin
      $display("BASIC RAPIDS TEST: All good!"); end
    else begin
      $display("BASIC RAPIDS TEST: Had errors!"); end
  $finish;
  end
endmodule
