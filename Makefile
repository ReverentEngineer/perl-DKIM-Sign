define check_perl_module
	@perl -e "use $(1);" 2> /dev/null || echo "Required perl module $(1) not installed"
endef

PREFIX := /usr/local

install: deps
	cp ./dkim_sign.pl $(PREFIX)/bin
.PHONY: install
	
test: ./run_tests.sh deps
	./run_tests.sh
.PHONY: test

deps:
	$(call check_perl_module,"YAML")
	$(call check_perl_module,"Mail::DKIM")
.PHONY: deps
