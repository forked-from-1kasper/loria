ARCHIVE=loria.tgz

tar:
	find resources -type f | tar cfz $(ARCHIVE) -T - --transform='s,resources/,,'
clean:
	rm $(ARCHIVE)
