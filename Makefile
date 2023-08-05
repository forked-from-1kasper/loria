FENNEL  ?= fennel
ARCHIVE  = loria
ROOT     = loria

SRC := $(shell find sources -type f -name '*.fnl')
DOCS := "COPYING\nAUTHORS\nLICENSE.TXT"
WORKINGDIR := $(shell pwd)

fennel: $(SRC:.fnl=.lua)
	# Fennel done

$(SRC:.fnl=.lua): %.lua: %.fnl
	$(FENNEL) --no-compiler-sandbox --compile $< > $@

tar: fennel
	(find resources -type f; find sources -type f -name "*.lua"; echo $(DOCS)) | \
	tar cfz $(ARCHIVE).tgz -T - --transform='s,resources/\|sources/,,'

root: tar
	mkdir -p $(ROOT)
	tar xzf $(ARCHIVE).tgz -C $(ROOT)

zip: root
	(cd $(ROOT); zip -r "$(WORKINGDIR)/$(ARCHIVE).zip" *)

clean:
	rm -f $(SRC:.fnl=.lua)
	rm -rf $(ROOT)/*
	rm -f $(ARCHIVE).*
