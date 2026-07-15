
SOURCES := $(wildcard *.pas)
TARGETS := $(SOURCES:%.pas=%)

BLAISEDIR := $(HOME)/apps/blaise/git/

RUNTIME := $(BLAISEDIR)runtime/src/main/pascal
STDLIB  := $(BLAISEDIR)stdlib/src/main/pascal
BLAISE  := $(BLAISEDIR)compiler/target/blaise

PC := $(BLAISE)
PFLAGS := --unit-path $(shell pwd)
PFLAGS += --unit-path $(RUNTIME)
PFLAGS += --unit-path $(STDLIB)
PFLAGS += --unit-path ..
ifdef NATIVE
PFLAGS += --backend native
else
PFLAGS += --backend qbe
PFLAGS += --emit-ir
endif

#$(info PFLAGS: $(PFLAGS))

all: $(TARGETS)

%: %.pas
	@printf "Compiling %s\n" $<
ifdef NATIVE
	@$(PC) --source $< --output $@ $(PFLAGS)
else
	@printf "Generating %s\n" $@.ssa
	@$(PC) --source $< $(PFLAGS) > $@.ssa
	@printf "Generating %s\n" $@.s
	@qbe -o $@.s $@.ssa
	@printf "Generating %s\n" $@
	@gcc -o $@ $@.s $(BLAISE)_rtl.a
endif
clean:
	@rm -fv *.s *.ssa

distclean: clean
	@rm -fv $(TARGETS)
