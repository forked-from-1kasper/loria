LUA     ?= lua5.1
FENNEL  ?= $(shell which fennel)
ARCHIVE  = loria
ROOT     = loria
SRCDIR   = sources
RESDIR   = resources
ARTFDIR  = build

SRC        := $(shell find $(SRCDIR) -type f -name '*.fnl')
MODULES    := $(SRC:$(SRCDIR)/%.fnl=%)
ARTF       := $(MODULES:%=$(ARTFDIR)/%.lua)
DOCS       := "COPYING\nAUTHORS\nLICENSE.TXT"
WORKINGDIR := $(shell pwd)

fennel: $(ARTFDIR) $(ARTF)
	# Fennel done

$(ARTFDIR):
	mkdir -p $(ARTFDIR)

$(ARTF): $(ARTFDIR)/%.lua: $(SRCDIR)/%.fnl
	mkdir -p `dirname $@`
	$(LUA) $(FENNEL) --no-compiler-sandbox --compile $< > $@~
	mv -f $@~ $@

tar: fennel
	(find $(RESDIR) -type f; find $(ARTFDIR) -type f -name "*.lua"; echo $(DOCS)) | \
	tar cfz $(ARCHIVE).tgz -T - --transform='s,$(RESDIR)/\|$(ARTFDIR)/,,'

root: tar
	mkdir -p $(ROOT)
	tar xzf $(ARCHIVE).tgz -C $(ROOT)

zip: root
	(cd $(ROOT); zip -r "$(WORKINGDIR)/$(ARCHIVE).zip" *)

clean:
	rm -rf $(ARTFDIR)
	rm -rf $(ROOT)/*
	rm -f $(ARCHIVE).*
