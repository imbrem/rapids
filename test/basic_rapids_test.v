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
    #10;
    rapids.mmu.memory[0] = 32'h9EF10004;//copy 4 to reg[1]
    rapids.mmu.memory[1] = 32'h9EF20006;//copy 6 to reg[2]
    rapids.mmu.memory[2] = 32'h80801020;// reg[1] += reg[2]
    rapids.mmu.memory[3] = 32'h9EF30040;//copy addr 64 to reg[3]
    rapids.mmu.memory[4] = 32'h213F0000;//Store reg[1] to addr in reg[3] select all
    rapids.mmu.memory[5] = 32'h143F0000;//Load memory[64] to reg[4]
    rapids.mmu.memory[6] = 32'hD0800010;
    rapids.mmu.memory[22] = 32'hC0800010;
    #4;
    go = 1;
    #2;
    go = 0;
    #50;

    if(rapids.D.registers[1] != 10) begin
      $display("BASIC RAPIDS TEST: basic arithemetic program test failed, expected 10 got %d",
      rapids.D.registers[1]
      );
      err = 1;
    end

    if(rapids.D.registers[4] != 10) begin
      $display("BASIC RAPIDS TEST: store and load program test failed, expected 10 got %d",
      rapids.D.registers[4]
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
