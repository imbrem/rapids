module meta_test;
  reg err;
  initial begin;
    $dumpfile("build/meta_test.vcd");
    $dumpvars;
    err = 0;
    if (!err) begin
      $display("META TEST: All good!"); end
    else begin
      $display("META TEST: Had errors!"); end
    $finish;
  end
endmodule
