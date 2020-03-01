define check_perl_module
	@perl -e "use $(1);" 2> /dev/null || echo "Required perl module $(1) not installed"
endef

ifndef PREFIX
	PREFIX := /usr/local
endif

VERSION := 0.1.1
INSTALL_PREFIX := $(DESTDIR)$(PREFIX)
SPECFILE := centos/perl-DKIM-Sign.spec
DIRS := bin share/man/man1
DIRS := $(addprefix $(INSTALL_PREFIX)/,$(DIRS))

$(DIRS):
	mkdir -p $@

install: deps $(DIRS) man
	cp ./bin/dkim_sign $(INSTALL_PREFIX)/bin
	cp dkim_sign.1.gz $(INSTALL_PREFIX)/share/man/man1
.PHONY: install
	
test: ./run_tests.sh deps
	./run_tests.sh
.PHONY: test

dkim_sign.1.gz: MAN.md
	pandoc -f markdown -s -t man $^ | gzip > $@

man: dkim_sign.1.gz
.PHONY: man

deps:
	$(call check_perl_module,"YAML")
	$(call check_perl_module,"Mail::DKIM")
.PHONY: deps

rpm:
	spectool -g -R --define '_version $(VERSION)' $(SPECFILE)
	rpmbuild -bb --define '_version $(VERSION)' $(SPECFILE)
.PHONY: rpm

clean:
	rm -f ./dkim_sign.1.gz
.PHONY: clean
