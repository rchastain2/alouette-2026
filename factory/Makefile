
SOURCES := $(filter-out board.pas constants.pas missingfunction.pas,$(wildcard *.pas))
TARGETS := $(SOURCES:%.pas=%)

PC := blaise
PFLAGS := --unit-path $(shell pwd)

all: $(TARGETS)

%: %.pas
	@printf "[INFO] Compiling %s\n" $<
	$(PC) --source $< --output $@ $(PFLAGS)
	@printf "[INFO] Executing %s\n" $@
	./$@ > $@.inc

clean:
	@rm -fv *.s *.ssa *.o

distclean: clean
	@rm -fv $(TARGETS) *.inc
