
SOURCES := $(wildcard *.pas)
TARGETS := $(SOURCES:%.pas=%)

PC := fpc
PFLAGS := -Mobjfpc -Sh

#$(info PFLAGS: $(PFLAGS))

all: $(TARGETS)

%: %.pas
	@$(PC) $< $(PFLAGS)

clean:
	@rm -fv *.o *.ppu

distclean: clean
	@rm -fv $(TARGETS)
