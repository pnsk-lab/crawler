PC = fpc
PCFLAGS =

.PHONY: all clean

all: crawl/crawl$(E)

crawl/crawl$(E): crawl/*.pas
	fpc -Mobjfpc -Sh -e$@ crawl/crawl.pas

clean:
	rm -f */*.ppu */*.o */*.exe crawl/crawl
