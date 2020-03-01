define check_perl_module
	@perl -e "use $(1);" 2> /dev/null || echo "Required perl module $(1) not installed"
endef

ifndef PREFIX
	PREFIX := /usr/local
endif
SPECFILE := centos/perl-DKIM-Sign.spec
DESTDIR := 

$(DESTDIR)$(PREFIX)/bin:
	mkdir -p $@

install: deps $(DESTDIR)$(PREFIX)/bin
	cp ./bin/dkim_sign $(DESTDIR)$(PREFIX)/bin
.PHONY: install
	
test: ./run_tests.sh deps
	./run_tests.sh
.PHONY: test

dkim_sign.1: MAN.md
	pandoc -f markdown -s -t man $^ -o $@	

man: dkim_sign.1
.PHONY: man

deps:
	$(call check_perl_module,"YAML")
	$(call check_perl_module,"Mail::DKIM")
.PHONY: deps

rpm:
	spectool -g -R $(SPECFILE)
	rpmbuild -bb $(SPECFILE)
.PHONY: rpm

clean:
	rm ./dkim_sign.1
.PHONY: clean
