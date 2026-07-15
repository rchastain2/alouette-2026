
SOURCES := $(filter-out board.pas constants.pas missingfunction.pas,$(wildcard *.pas))
TARGETS := $(SOURCES:%.pas=%)

BLAISEDIR := $(HOME)/apps/blaise/git/

BLAISE  := $(BLAISEDIR)compiler/target/blaise
RUNTIME := $(BLAISEDIR)runtime/src/main/pascal
STDLIB  := $(BLAISEDIR)stdlib/src/main/pascal

PC := $(BLAISE)
PFLAGS := --unit-path $(shell pwd)
PFLAGS += --unit-path $(RUNTIME)
PFLAGS += --unit-path $(STDLIB)
PFLAGS += --emit-ir

all: $(TARGETS)

%: %.pas
	@printf "[INFO] Generating %s\n" $@.ssa
	$(PC) --source $< $(PFLAGS) > $@.ssa
	@printf "[INFO] Generating %s\n" $@.s
	qbe -o $@.s $@.ssa
	@printf "[INFO] Generating %s\n" $@
	gcc -o $@ $@.s $(BLAISE)_rtl.a
	@printf "[INFO] Executing %s\n" $@
	./$@ > $@.inc

clean:
	@rm -fv *.s *.ssa

distclean: clean
	@rm -fv $(TARGETS)
