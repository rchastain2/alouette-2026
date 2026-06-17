
SOURCES := $(wildcard *.pas)
TARGETS := $(SOURCES:%.pas=%)

PC := fpc
PFLAGS := -Mobjfpc -Sh
PFLAGS += -Fu..

#$(info PFLAGS: $(PFLAGS))

all: $(TARGETS)

%: %.pas
	@$(PC) $< $(PFLAGS)

clean:
	@rm -fv *.o *.ppu

distclean: clean
	@rm -fv $(TARGETS)
