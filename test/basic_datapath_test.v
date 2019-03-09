module basic_datapath_test;
  reg err;

  reg clk;
  reg[2:0] op;
  reg form;
  reg[1:0] vec;
  reg[3:0] A;
  reg[3:0] B;
  reg[3:0] C;
  reg[3:0] D;
  reg[3:0] Y1, Y2;
  reg[3:0] zero_reg;
  reg[1:0] write;
  reg const_a;
  reg[31:0] constant;

  datapath datapath(
    .clk(clk),
    .op(op),
    .form(form),
    .vec(vec),
    .A(A),
    .B(B),
    .C(C),
    .D(D),
    .zero_reg(zero_reg),
    .Y1(Y1),
    .Y2(Y2),
    .write(write),
    .const_a(const_a),
    .constant(constant)
    );

  always begin
    clk = 1'b0; #1; clk = 1'b1; #1;
  end

  initial begin
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
    zero_reg = 4'b1110;
    Y1 = 1;
    Y2 = 0;
    write = 1;
    const_a = 1;
    constant = 5;
    #2;

    if(datapath.registers[1] !== 5) begin
      $display(
        "BASIC DATAPATH TEST: Wrong register 1 value %d, expected 5",
        datapath.registers[1]
        );
      err = 1;
    end

    zero_reg = 4'b1110;
    Y1 = 2;
    Y2 = 0;
    write = 1;
    const_a = 1;
    constant = 7;
    #2;

    if(datapath.registers[1] !== 5) begin
      $display(
        "BASIC DATAPATH TEST: Wrong register 1 value %d, expected 5",
        datapath.registers[1]
        );
      err = 1;
    end

    if(datapath.registers[2] !== 7) begin
      $display(
        "BASIC DATAPATH TEST: Wrong register 2 value %d, expected 7",
        datapath.registers[2]
        );
      err = 1;
    end

    if (!err) begin
      $display("BASIC DATAPATH TEST: All good!"); end
    else begin
      $display("BASIC DATAPATH TEST: Had errors!"); end
    $finish;
  end
endmodule
