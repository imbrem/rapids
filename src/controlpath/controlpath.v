module controlpath(
    input go,
    input halt,
    input clk,
    input[31:0] instruction,
    input instr_segv,
    input data_segv,
    input wait_instr,
    input wait_data,
    output reg pc_inc,
    output reg[2:0] opcode,
    output alu_form,
    output[1:0] alu_vec_perci,
    output[3:0] alu_config,
    output const_c,
    output[31:0] constant,
    output reg[3:0] a_select,
    output[3:0] alu_b_select,
    output[3:0] alu_c_select,
    output[3:0] alu_d_select,
    output[3:0] alu_Y1_select,
    output[3:0] alu_Y2_select,
    output reg[1:0] reg_write,
    output reg[3:0] op_select,
    output reg st,
    output reg ld,
    output[3:0] mem_loca_addr,
    output[3:0] reg_addr
  );

  localparam
    HALT = 5'b00000,
    READ_INS = 5'b01000,
    WAIT_LOAD = 5'b01010,
    WAIT_STORE = 5'b01100,
    DO = 5'b01001,
    TRAP = 5'b10000;

  //output of the modularized FSM
  wire[4:0] current_state;

  reg invalid_instruction;

  //wire naming for the Operation mux
  wire[2:0] alu_op, sl_op;
  wire[3:0] alu_a, sl_a;
  wire[1:0] alu_write, sl_write;
  wire[3:0] logic_select, sl_select;
  wire instr_pc, instr_alu;
  wire invalid_alu_instruction, invalid_mmu_instruction;
  //register naming for state dependant Op Mux
  reg[1:0] reg_write_raw;
  wire ld_raw, st_raw;

  assign {instr_alu, pc} = instruction[31:30];

  //Raw Operation Mux
  always @(*) begin
    opcode = instr_alu ? alu_op : sl_op;
    reg_write_raw = instr_alu ? alu_write : sl_write;
    op_select = instr_alu ? logic_select : sl_select;
    a_select = instr_alu ? alu_a : sl_a;
    invalid_instruction = instr_alu ? invalid_alu_instruction : invalid_mmu_instruction;
  end
  //State dependant operation Mux
  always @(*) begin
    {reg_write, pc_inc} = current_state == DO ? {reg_write_raw, 1'b1} : 3'b0;
    ld = current_state == WAIT_LOAD ? ld_raw : 0;
    st = current_state == WAIT_STORE ? st_raw : 0;
  end

  //controlpath needs mux for different type of operations ie. PC
  alu_instruction_decoder d0(
    .instruction(instruction),
    .invalid_instruction(invalid_alu_instruction),
    .alu_op(alu_op),
    .alu_vec_perci(alu_vec_perci),
    .alu_form(alu_form),
    .alu_config(alu_config),
    .const_c(const_c),
    .constant(constant),
    .alu_a_select(alu_a),
    .alu_b_select(alu_b_select),
    .alu_c_select(alu_c_select),
    .alu_d_select(alu_d_select),
    .alu_Y1_select(alu_Y1_select),
    .alu_Y2_select(alu_Y2_select),
    .logic_select(logic_select),
    .alu_write(alu_write)
    );

  mmu_decoder d1(
    .instruction(instruction[29:0]),
    .invalid_instruction(invalid_mmu_instruction),
    .reg_addr(sl_a),
    .mem_loca_addr(mem_loca_addr),
    .st(st_raw),
    .ld(ld_raw),
    .sl_select(sl_select),
    .sl_op(sl_op),
    .write(sl_write)
    );

  FSM controlfsm(
    .clk(clk),
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
