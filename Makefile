IFLAGS = -Wall
ALU_FILES = src/datapath/alu/alu.v \
	src/datapath/alu/alu_modules/adder.v \
	src/datapath/alu/alu_modules/subtractor.v \
	src/datapath/alu/alu_modules/logic_unit.v \
	src/datapath/alu/alu_modules/comparetor.v \
	src/datapath/alu/alu_modules/shifter.v
DATAPATH_FILES = src/datapath/datapath.v $(ALU_FILES)
DECODER_FILES = 	src/controlpath/decoders/mmu_decoder.v \
src/controlpath/decoders/alu_instruction_decoder.v
CONTROLPATH_FILES = src/controlpath/controlpath.v \
	src/controlpath/FSM.v $(DECODER_FILES)
MMU_FILES = src/memory/mmu.v
ALL_FILES = src/rapids.v $(CONTROLPATH_FILES) $(DATAPATH_FILES) $(MMU_FILES)

all: build/meta_test build/alu_test \
	build/basic_datapath_test \
	build/alu_instruction_decoder_test \
	build/basic_controlpath_test \
	build/basic_rapids_test \
	build/mmu_test \
	build/logic_unit_test \
	build/FSM_test

test: build/meta_test.vcd \
	build/alu_test.vcd \
	build/basic_datapath_test.vcd \
	build/alu_instruction_decoder_test.vcd \
	build/basic_controlpath_test.vcd \
	build/basic_rapids_test.vcd \
	build/mmu_test.vcd \
	build/logic_unit_test.vcd \
	build/FSM_test.vcd

build/meta_test.vcd: build/meta_test
	vvp build/meta_test

build/alu_test.vcd: build/alu_test
	vvp build/alu_test

build/basic_datapath_test.vcd: build/basic_datapath_test
	vvp build/basic_datapath_test

build/alu_instruction_decoder_test.vcd: build/alu_instruction_decoder_test
	vvp build/alu_instruction_decoder_test

build/basic_controlpath_test.vcd: build/basic_controlpath_test
	vvp build/basic_controlpath_test

build/basic_rapids_test.vcd: build/basic_rapids_test
	vvp build/basic_rapids_test

build/mmu_test.vcd: build/mmu_test
	vvp build/mmu_test

build/logic_unit_test.vcd: build/logic_unit_test
	vvp build/logic_unit_test

build/FSM_test.vcd: build/FSM_test
	vvp build/FSM_test

build/meta_test: test/meta_test.v
	mkdir -p build
	iverilog $(IFLAGS) -o build/meta_test test/meta_test.v

build/alu_test: test/alu_test.v $(ALU_FILES)
	mkdir -p build
	iverilog $(IFLAGS) -o build/alu_test test/alu_test.v $(ALU_FILES)

build/basic_datapath_test: test/basic_datapath_test.v $(DATAPATH_FILES)
	mkdir -p build
	iverilog $(IFLAGS) -o build/basic_datapath_test \
		test/basic_datapath_test.v $(DATAPATH_FILES)

build/alu_instruction_decoder_test: test/alu_instruction_decoder_test.v $(DECODER_FILES)
	mkdir -p build
	iverilog $(IFLAGS) -o build/alu_instruction_decoder_test \
		test/alu_instruction_decoder_test.v $(DECODER_FILES)

build/basic_controlpath_test: test/basic_controlpath_test.v $(CONTROLPATH_FILES)
	mkdir -p build
	iverilog $(IFLAGS) -o build/basic_controlpath_test \
		test/basic_controlpath_test.v $(CONTROLPATH_FILES)

build/basic_rapids_test: test/basic_rapids_test.v $(ALL_FILES)
	mkdir -p build
	iverilog $(IFLAGS) -o build/basic_rapids_test test/basic_rapids_test.v $(ALL_FILES)

build/mmu_test: test/mmu_test.v $(MMU_FILES)
	mkdir -p build
	iverilog $(IFLAGS) -o build/mmu_test test/mmu_test.v $(MMU_FILES)

build/logic_unit_test: test/logic_unit_test.v $(ALU_FILES)
	mkdir -p build
	iverilog $(IFLAGS) -o build/logic_unit_test test/logic_unit_test.v $(ALU_FILES)

build/FSM_test: test/FSM_test.v $(CONTROLPATH_FILES)
	mkdir -p build
	iverilog $(IFLAGS) -o build/FSM_test test/FSM_test.v $(CONTROLPATH_FILES)

clean:
	rm -f build/*
