#FENNEL = # May be set here
ARCHIVE = loria.tgz
ROOT = loria

SRC := $(shell find sources -type f -name '*.fnl')
DOCS := "COPYING\nAUTHORS\nLICENSE.TXT"

fennel: $(SRC:.fnl=.lua)
	# Fennel done

$(SRC:.fnl=.lua): %.lua: %.fnl
	$(FENNEL) --compile $< > $@

tar: fennel
	(find resources -type f; find sources -type f -name "*.lua"; echo $(DOCS)) | \
	tar cfz $(ARCHIVE) -T - --transform='s,resources/\|sources/,,'

root: tar
	mkdir -p $(ROOT)
	tar xzf $(ARCHIVE) -C $(ROOT)

clean:
	rm -f $(SRC:.fnl=.lua)
	rm -f $(ARCHIVE)
