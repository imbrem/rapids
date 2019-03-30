module controlpath(
    input clk,
    input[31:0] instruction,
    input instr_segv,
    input data_segv,
    input wait_instr,
    input wait_data,
    output pc_inc,
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
    output st,
    output ld,
    output[3:0] mem_loca_addr,
    output[3:0] reg_addr
  );

  reg[3:0] current_state, next_state;
  wire invalid_instruction;
  wire[2:0] alu_op, sl_op;
  wire[3:0] alu_a, sl_a;
  wire[1:0] alu_write, sl_write;
  wire[3:0] logic_select, sl_select;
  wire instr_pc, instr_alu;
  assign {instr_pc, instr_alu} = instruction[1:0];

  //Mux between alu operations and memory operations.
  always @(*) begin
    opcode = instr_alu ? alu_op : sl_op;
    reg_write = instr_alu ? alu_write : sl_write;
    op_select = instr_alu ? logic_select : sl_select;
    a_select = instr_alu ? alu_a : sl_a;
  end
  //controlpath needs mux for different type of operations ie. PC
  alu_instruction_decoder d0(
    .instruction(instruction),
    .invalid_instruction(invalid_instruction),
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
    .instruction(instruction[31:2]),
    .reg_addr(sl_a),
    .mem_loca_addr(mem_loca_addr),
    .st(st),
    .ld(ld),
    .sl_select(sl_select),
    .sl_op(sl_op),
    .write(sl_write)
    );
endmodule
