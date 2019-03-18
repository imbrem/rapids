module basic_controlpath_test;
  reg err;

  initial begin
  $dumpfile("build/basic_controlpath_test.vcd");
  $dumpvars;

  err = 0;

    if (!err) begin
      $display("BASIC CONTROLPATH TEST: All good!"); end
    else begin
      $display("BASIC CONTROLPATH TEST: Had errors!"); end
  $finish;
  end
endmodule
