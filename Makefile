ALU_FILES = src/datapath/alu/alu.v \
	src/datapath/alu/adder.v \
	src/datapath/alu/subtractor.v
DATAPATH_FILES = src/datapath/datapath.v $(ALU_FILES)

all: build/meta_test build/alu_test build/basic_datapath_test

test: build/meta_test.vcd build/alu_test.vcd build/basic_datapath_test.vcd

build/meta_test.vcd: build/meta_test
	vvp build/meta_test

build/alu_test.vcd: build/alu_test
	vvp build/alu_test

build/basic_datapath_test.vcd: build/basic_datapath_test
	vvp build/basic_datapath_test

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

clean:
	rm -f build/*
