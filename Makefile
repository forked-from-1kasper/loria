ARCHIVE = loria.tgz
SRC := $(shell find sources -type f -name '*.fnl')
DOCS := "COPYING\nAUTHORS\nLICENSE.TXT"

fennel: $(SRC:.fnl=.lua)
	# Fennel done

$(SRC:.fnl=.lua): %.lua: %.fnl
	fennel --compile $< > $@

tar:
	(find resources -type f; find sources -type f -name "*.lua"; echo $(DOCS)) | \
	tar cfz $(ARCHIVE) -T - --transform='s,resources/\|sources/,,'
clean:
	rm -f $(SRC:.fnl=.lua)
	rm -f $(ARCHIVE)
