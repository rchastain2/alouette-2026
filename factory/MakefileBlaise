
SOURCES := $(filter-out board.pas constants.pas missingfunction.pas,$(wildcard *.pas))
TARGETS := $(SOURCES:%.pas=%)

BLAISEDIR := $(HOME)/apps/blaise/git/

BLAISE  := $(BLAISEDIR)compiler/target/blaise
#RUNTIME := $(BLAISEDIR)runtime/src/main/pascal
STDLIB  := $(BLAISEDIR)stdlib/src/main/pascal

PC := $(BLAISE)
PFLAGS := --unit-path $(shell pwd)
#PFLAGS += --rtl-src $(RUNTIME)
PFLAGS += --unit-path $(STDLIB)
ifdef NATIVE
PFLAGS += --backend native
else
PFLAGS += --backend qbe
PFLAGS += --emit-ir
endif

all: $(TARGETS)

%: %.pas
	@printf "[INFO] Compiling %s\n" $<
ifdef NATIVE
	$(PC) --source $< --output $@ $(PFLAGS)
else
	@printf "[INFO] Generating %s\n" $@.ssa
	$(PC) --source $< $(PFLAGS) > $@.ssa
	@printf "[INFO] Generating %s\n" $@.s
	qbe -o $@.s $@.ssa
	@printf "[INFO] Generating %s\n" $@
	gcc -o $@ $@.s $(BLAISE)_rtl.a
endif
	@printf "[INFO] Executing %s\n" $@
	./$@ > $@.inc

clean:
	@rm -fv *.s *.ssa *.o

distclean: clean
	@rm -fv $(TARGETS) *.inc
