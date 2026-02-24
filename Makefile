PC = fpc
PCFLAGS =

.PHONY: all clean

all: axe/axe$(E) hammer/hammer$(E)

axe/axe$(E): axe/*.pas
	fpc -Mobjfpc -Sh $(PCFLAGS) -e$@ axe/axe.pas

hammer/hammer$(E): hammer/*.pas
	@echo "$(PCFLAGS)" | grep -- "-dDATABASE" >/dev/null 2>&1 ; if [ "$$?" = "0" ]; then \
		echo "fpc -Mobjfpc -Sh $(PCFLAGS) -e$@ hammer/hammer.pas" ; \
		fpc -Mobjfpc -Sh $(PCFLAGS) -e$@ hammer/hammer.pas ; \
	fi

clean:
	rm -f */*.ppu */*.o */*.exe axe/axe hammer/hammer
