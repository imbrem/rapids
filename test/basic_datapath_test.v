module basic_datapath_test;
  reg err;

  reg clk;
  reg pc_inc;
  reg jump;
  reg reset_n;
  reg[2:0] op;
  reg form;
  reg[1:0] vec;
  reg[3:0] A;
  reg[3:0] B;
  reg[3:0] C;
  reg[3:0] D;
  reg[3:0] Y1, Y2;
  reg[1:0] write;
  reg const_c;
  reg[31:0] constant;
  reg[3:0] logic_select;
  reg condition;
  reg[2:0] compare_op;
  reg[3:0] mem_loca_addr;
  reg[31:0] ld_data;
  reg ld;
  wire[31:0] st_data;
  wire[31:0] program_counter;
  wire[31:0] mem_loca;

  localparam
    ADD = 3'b000,
    SUB = 3'b100,
    MULT = 3'b001,
    DIV = 3'b101,
    AND = 3'b010,
    OR = 3'b011,
    XOR = 3'b110,
    COPY = 3'b111;

  datapath datapath(
    .clk(clk),
    .pc_inc(pc_inc),
    .reset_n(reset_n),
    .jump(jump),
    .alu_op(op),
    .form(form),
    .vec(vec),
    .A(A),
    .B(B),
    .C(C),
    .D(D),
    .Y1(Y1),
    .Y2(Y2),
    .write(write),
    .const_c(const_c),
    .constant(constant),
    .logic_select(logic_select),
    .mem_loca_addr(mem_loca_addr),
    .ld_data(ld_data),
    .ld(ld),
    .st_data(st_data),
    .program_counter(program_counter),
    .mem_loca(mem_loca),
    .condition(condition),
    .compare_op(compare_op)
    );

  always begin
    clk = 1'b0; #1; clk = 1'b1; #1;
  end

  initial begin
    $dumpfile("build/basic_datapath_test.vcd");
    $dumpvars;

    err = 0;

    pc_inc = 1;
    reset_n = 0;
    jump = 0;
    op = ADD;
    form = 0;
    vec = 0;
    A = 0;
    B = 0;
    C = 0;
    D = 0;
    Y1 = 1;
    Y2 = 0;
    write = 1;
    const_c = 1;
    constant = 5;
    mem_loca_addr = 0;
    ld_data = 0;
    condition = 0;
    compare_op = 0;
    #2;

    if(datapath.registers[1] !== 5) begin
      $display(
        "BASIC DATAPATH TEST: Wrong register 1 value %d, expected 5",
        datapath.registers[1]
        );
      err = 1;
    end

    Y1 = 2;
    Y2 = 0;
    write = 1;
    const_c = 1;
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

    A = 1;
    C = 2;
    Y1 = 3;
    Y2 = 0;
    write = 0;
    const_c = 1;
    constant = 9;
    #5;

    const_c = 0;
    constant = 11;
    #5;

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

    write = 1;
    #2

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

    if(datapath.registers[3] !== 12) begin
      $display(
        "BASIC DATAPATH TEST: Wrong register 3 value %d, expected 12",
        datapath.registers[3]
        );
      err = 1;
    end

    op = SUB;
    form = 1;
    A = 3;
    B = 1;
    C = 2;
    Y2 = 3;
    write = 2'b10;
    #2

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

    if(datapath.registers[3] !== 0) begin
      $display(
        "BASIC DATAPATH TEST: Wrong register 3 value %d, expected 0",
        datapath.registers[3]
        );
      err = 1;
    end

    write = 0;
    pc_inc = 0;
    #2;

    if(datapath.registers[3] !== 0) begin
      $display(
        "BASIC DATAPATH TEST: Wrong register 3 value %d, expected 0",
        datapath.registers[3]
        );
      err = 1;
    end

    pc_inc = 1;
    #2

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
