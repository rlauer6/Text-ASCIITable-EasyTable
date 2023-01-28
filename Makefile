MODULE = Text::ASCIITable::EasyTable

AUTHOR = 'BIGFOOT <bigfoot@cpan.org>'

PERL_MODULES = \
    lib/Text/ASCIITable/EasyTable.pm

DESCRIPTION = "Create ASCII tables easily"

UNIT_TESTS = \
	t/00-easy-table.t

TARBALL = Text-ASCIITable-EasyTable.tar.gz

all: README.md $(TARBALL)

$(TARBALL): $(PERL_MODULES) $(PERL_SCRIPTS) requires
	 make-cpan-dist \
	   -e bin \
	   -l lib \
	   -c \
	   -M 5.016 \
	   -m $(MODULE) \
	   -a $(AUTHOR) \
	   -T test-requires \
	   -t t/ \
	   -d $(DESCRIPTION) \
	   -H . \
	   -D requires \
	cp $$(ls -1rt *.tar.gz | tail -1) $@

README.md: $(PERL_MODULES)
	pod2markdown $< > $@ || rm -f $@

.PHONY: check

check: $(PERL_MODULES)
	PERL5LIB=$(builddir)/lib perl -wc $(PERL_MODULES)
	perlcritic -1 $(PERL_MODULES)
	$(MAKE) test

test: $(TESTS)
	prove -v t/

install: $(TARBALL)
	cpanm -v $<

clean:
	rm -f $(TARBALL) $(README)
