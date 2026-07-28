
SOURCES := $(wildcard *.pas)
TARGETS := $(SOURCES:%.pas=%)

PC := blaise
PFLAGS := --unit-path ..

all: $(TARGETS)

%: %.pas
	@printf "Compiling %s\n" $<
	$(PC) --source $< --output $@ $(PFLAGS)

clean:
	@rm -fv *.s *.ssa *.o

distclean: clean
	@rm -fv $(TARGETS)
