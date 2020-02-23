define check_perl_module
	@perl -e "use $(1);" 2> /dev/null || echo "Required perl module $(1) not installed"
endef

install: deps
	cp ./dkim_sign.pl /usr/local/bin
.PHONY: install
	
test: ./run_tests.sh deps
	./run_tests.sh
.PHONY: test

deps:
	$(call check_perl_module,"YAML")
	$(call check_perl_module,"Mail::DKIM")
.PHONY: deps
