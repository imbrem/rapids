all: build/meta_test build/alu_test

test: meta_test alu_test

.PHONY: meta_test
meta_test: build/meta_test
	vvp build/meta_test

.PHONY: alu_test
alu_test: build/alu_test
	vvp build/alu_test

build/meta_test: test/meta_test.v
	iverilog -o build/meta_test test/meta_test.v

build/alu_test: test/alu_test.v src/alu/alu.v
	iverilog -o build/alu_test test/alu_test.v src/alu/alu.v
