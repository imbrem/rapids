ALU_FILES = src/datapath/alu/alu.v \
	src/datapath/alu/adder.v \
	src/datapath/alu/subtractor.v \
	src/datapath/alu/copier.v
DATAPATH_FILES = src/datapath/datapath.v $(ALU_FILES)
CONTROLPATH_FILES = src/controlpath/alu_instruction_decoder.v \
	src/controlpath/controlpath.v

all: build/meta_test build/alu_test \
	build/basic_datapath_test \
	build/alu_instruction_decoder_test \
	build/basic_controlpath_test \
	build/basic_rapids_test

test: build/meta_test.vcd \
	build/alu_test.vcd \
	build/basic_datapath_test.vcd \
	build/alu_instruction_decoder_test.vcd \
	build/basic_controlpath_test.vcd \
	build/basic_rapids_test.vcd

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

build/meta_test: test/meta_test.v
	mkdir -p build
	iverilog -o build/meta_test test/meta_test.v

build/alu_test: test/alu_test.v $(ALU_FILES)
	mkdir -p build
	iverilog -o build/alu_test test/alu_test.v $(ALU_FILES)

build/basic_datapath_test: test/basic_datapath_test.v $(DATAPATH_FILES)
	mkdir -p build
	iverilog -o build/basic_datapath_test \
		test/basic_datapath_test.v $(DATAPATH_FILES)

build/alu_instruction_decoder_test: test/alu_instruction_decoder_test.v $(CONTROLPATH_FILES)
	mkdir -p build
	iverilog -o build/alu_instruction_decoder_test \
		test/alu_instruction_decoder_test.v $(CONTROLPATH_FILES)

build/basic_controlpath_test: test/basic_controlpath_test.v $(CONTROLPATH_FILES)
	mkdir -p build
	iverilog -o build/basic_controlpath_test \
		test/basic_controlpath_test.v $(CONTROLPATH_FILES)

build/basic_rapids_test: test/basic_rapids_test.v $(CONTROLPATH_FILES, DATAPATH_FILES)
	mkdir -p build
	iverilog -o build/basic_rapids_test \
		test/basic_rapids_test.v $(CONTROLPATH_FILES, DATAPATH_FILES)

clean:
	rm -f build/*
