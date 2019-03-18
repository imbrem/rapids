module basic_rapids_test;
  reg err;

  initial begin
    $dumpfile("build/basic_rapids_test.vcd");
    $dumpvars;

    err = 0;

    if (!err) begin
      $display("BASIC RAPIDS TEST: All good!"); end
    else begin
      $display("BASIC RAPIDS TEST: Had errors!"); end
  $finish;
  end
endmodule
