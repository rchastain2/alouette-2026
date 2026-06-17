
SOURCES := $(wildcard *.pas)
TARGETS := $(SOURCES:%.pas=%)

BLAISEDIR := ~/opt/blaise/

BLAISE  := $(BLAISEDIR)compiler/target/blaise
RUNTIME := $(BLAISEDIR)runtime/src/main/pascal
STDLIB  := $(BLAISEDIR)stdlib/src/main/pascal

PC := $(BLAISE)
PFLAGS := --unit-path $(shell pwd)
PFLAGS += --unit-path $(RUNTIME)
PFLAGS += --unit-path $(STDLIB)
PFLAGS += --emit-ir

#$(info PFLAGS: $(PFLAGS))

all: $(TARGETS)

%: %.pas
	@printf "Generating %s\n" $@.ssa
	@$(PC) --source $< $(PFLAGS) > $@.ssa
	@printf "Generating %s\n" $@.s
	@qbe -o $@.s $@.ssa
	@printf "Generating %s\n" $@
	@gcc -o $@ $@.s $(BLAISE)_rtl.a
	@./$@ > $@.inc

clean:
	@rm -fv *.s *.ssa

distclean: clean
	@rm -fv $(TARGETS)
