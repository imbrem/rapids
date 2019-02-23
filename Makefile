ALU_FILES = src/alu/alu.v src/alu/integer/int_adder.v

all: build/meta_test build/alu_test

test: build/meta_test.vcd build/alu_test.vcd

build/meta_test.vcd: build/meta_test
	vvp build/meta_test

build/alu_test.vcd: build/alu_test
	vvp build/alu_test

build/meta_test: test/meta_test.v
	iverilog -o build/meta_test test/meta_test.v

build/alu_test: test/alu_test.v $(ALU_FILES)
	iverilog -o build/alu_test test/alu_test.v $(ALU_FILES)
