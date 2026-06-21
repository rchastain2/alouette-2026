
PASDOC := $(HOME)/apps/pasdoc/1_0_4/bin/pasdoc
DIR := html-doc

doc: files.txt $(DIR)
	$(PASDOC) --output=$(DIR) --language=fr.utf8 --staronly --source=$<

$(DIR):
	mkdir -p $@
