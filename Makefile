.PHONY: meta_test
meta_test: build/meta_test
	vvp build/meta_test

build/meta_test: test/meta_test.v
	iverilog -o build/meta_test test/meta_test.v
