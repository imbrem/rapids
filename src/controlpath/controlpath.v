module controlpath(
    input go,
    input halt,
    input clk,
    input reset_n,
    input[31:0] instruction,
    //inputs from mmu
    input instr_segv,
    input data_segv,
    input wait_instr,
    input wait_data,
    output reg pc_inc,
    output jump,
    //control signals for alu
    output reg[2:0] opcode,
    output reg form,
    output[1:0] alu_vec_perci,
    output[3:0] alu_config,
    output reg const_c,
    output[31:0] constant,
    output reg[3:0] a_select, //*
    output[3:0] alu_b_select,
    output[3:0] alu_c_select,
    output[3:0] alu_d_select,
    output reg[3:0] Y1_select,
    output[3:0] alu_Y2_select,
    output reg[1:0] reg_write, //*
    output reg[3:0] op_select, //*
    output reg condition,
    output[2:0] compare_op,
    //control signals for mmu
    output reg st,
    output reg ld,
    output[3:0] mem_loca_addr
  );

  localparam
    HALT = 5'b00000,
    READ_INS = 5'b01000,
    WAIT_LOAD = 5'b01010,
    WAIT_STORE = 5'b01100,
    DO = 5'b01001,
    TRAP = 5'b10000;
  //00  STORE/LOAD
  //01  SPECIAL
  //10  ARITHMETIC
  //11  JUMP

  //General wire declariation
  wire[4:0] current_state;
  reg[31:0] instr_reg;
  reg invalid_instruction;
  wire instr_pc, instr_alu;
  wire reg_instr_alu, reg_instr_pc;
  //General assignments
  assign {reg_instr_alu, reg_instr_pc} = instr_reg[31:30];
  assign {instr_alu, instr_pc} = instruction[31:30];
  assign jump = reg_instr_pc & reg_instr_alu;


  //wire naming for the Operation mux
  wire[2:0] alu_op, sl_op;
  wire[3:0] alu_a, sl_a;
  wire[3:0] alu_Y1_select;
  wire[1:0] alu_write, sl_write;
  wire[3:0] logic_select, sl_select;
  wire alu_form, sl_neg;
  wire alu_const_c, sl_const_c;
  wire alu_condition, sl_condition;
  wire invalid_alu_instruction, invalid_mmu_instruction;
  //wire naming for state dependant Op Mux
  reg[1:0] reg_write_raw;
  wire ld_raw, st_raw;

  //Raw Operation Mux
  always @(*) begin
    opcode = reg_instr_alu ? alu_op : sl_op;
    form = reg_instr_alu ? alu_form : sl_neg;
    reg_write_raw = reg_instr_alu ? alu_write : sl_write;
    op_select = reg_instr_alu ? logic_select : sl_select;
    a_select = reg_instr_alu ? alu_a : sl_a;
    Y1_select = reg_instr_alu ? alu_Y1_select : sl_a;
    const_c = reg_instr_alu ? alu_const_c : sl_const_c;
    condition = (reg_instr_alu & reg_instr_pc) ? alu_condition : sl_condition;
    invalid_instruction = reg_instr_alu ? invalid_alu_instruction : invalid_mmu_instruction;
  end
  //State dependant operation Mux
  always @(*) begin
    {reg_write, pc_inc} = (current_state == DO & ~invalid_instruction) ? {reg_write_raw, ~reg_instr_pc} : 3'b0;
    if (~reg_instr_pc & ~reg_instr_alu) begin
      ld = (current_state == WAIT_LOAD | current_state == DO) ? ld_raw : 0;
      st = (current_state == WAIT_STORE | current_state == DO) ? st_raw : 0;
    end
    else {ld, st} = 0;
  end

  //initial reset
  initial begin
    {opcode, reg_write_raw, op_select, a_select, invalid_instruction} = 0;
    instr_reg <= 32'b0;
    {reg_write, pc_inc, ld, st} = 0;
  end

  //instruction store
  always @(posedge clk) begin
    if(current_state == READ_INS)
      instr_reg <= instruction;
  end
  //controlpath needs mux for different type of operations ie. PC
  alu_instruction_decoder d0(
    .instruction(instruction),
    .invalid_instruction(invalid_alu_instruction),
    .alu_op(alu_op),
    .alu_vec_perci(alu_vec_perci),
    .alu_form(alu_form),
    .const_c(alu_const_c),
    .constant(constant),
    .alu_a_select(alu_a),
    .alu_b_select(alu_b_select),
    .alu_c_select(alu_c_select),
    .alu_d_select(alu_d_select),
    .alu_Y1_select(alu_Y1_select),
    .alu_Y2_select(alu_Y2_select),
    .logic_select(logic_select),
    .alu_write(alu_write),
    .condition(alu_condition),
    .compare_op(compare_op)
    );

  mmu_decoder d1(
    .instruction(instruction),
    .invalid_instruction(invalid_mmu_instruction),
    .reg_addr(sl_a),
    .mem_loca_addr(mem_loca_addr),
    .st(st_raw),
    .ld(ld_raw),
    .sl_select(sl_select),
    .sl_neg(sl_neg),
    .sl_op(sl_op),
    .sl_const_c(sl_const_c),
    .sl_condition(sl_condition),
    .write(sl_write)
    );

  FSM controlfsm(
    .clk(clk),
    .reset_n(reset_n),
    .go(go),
    .halt(halt),
    .instr_alu(instr_alu),
    .instr_pc(instr_pc),
    .ld(ld_raw),
    .st(st_raw),
    .wait_data(wait_data),
    .wait_instr(wait_instr),
    .data_segv(data_segv),
    .instr_segv(instr_segv),
    .invalid_instruction(invalid_instruction),
    .current_state(current_state)
    );

endmodule
