module basic_datapath_test;
  reg err;

  reg[2:0] op;
  reg form;
  reg[1:0] vec;
  reg[3:0] A;
  reg[3:0] B;
  reg[3:0] C;
  reg[3:0] D;

  datapath datapath(
    .op(op),
    .form(form),
    .vec(vec),
    .A(A),
    .B(B),
    .C(C),
    .D(D)
    );

  initial begin;
    $dumpfile("build/basic_datapath_test.vcd");
    $dumpvars;

    err = 0;

    op = 0;
    form = 0;
    vec = 0;
    A = 0;
    B = 0;
    C = 0;
    D = 0;
    #1;

    if (!err) begin
      $display("BASIC DATAPATH TEST: All good!"); end
    else begin
      $display("BASIC DATAPATH TEST: Had errors!"); end
    $finish;
  end
endmodule
