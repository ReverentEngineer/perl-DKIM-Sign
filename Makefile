install:
	cp ./dkim_sign.pl /usr/local/bin
.PHONY: install
	
test: ./run_tests.sh
	./run_tests.sh
.PHONY: test
