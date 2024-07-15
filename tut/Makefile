TUT_SRC_DIR  = $(addprefix , tut)
ifdef FILE
TUT_FILES = $(TUT_SRC_DIR)/$(FILE)
else
TUT_FILES ?= $(foreach sdir, $(TUT_SRC_DIR), $(wildcard $(sdir)/*.qmd))
endif

HTML_FILES := $(patsubst %.qmd, %.html, $(TUT_FILES))
PUBLIC_DIR := public/
# DOCS_DIR   := $(addprefix , ./)
DOCS_DIR   := $(addprefix , docs/)
DOCS_HTML_FILES := $(patsubst $(TUT_SRC_DIR)/%.qmd, $(DOCS_DIR)%.html, $(TUT_FILES))
FILES := $(patsubst $(TUT_SRC_DIR)/%.qmd, %.html, $(TUT_FILES))

$(info ************************************)
$(info TUT Source directory:     $(TUT_SRC_DIR))
$(info TUT Source files:         $(TUT_FILES))
$(info TUT HTML files:           $(HTML_FILES))
$(info DOC HTML files:           $(DOCS_HTML_FILES))
$(info PUBLIC_DIR:              $(PUBLIC_DIR))
$(info DOCS_DIR:              $(DOCS_DIR))
$(info FILES:                 $(FILES))
$(info ************************************)

.PHONY: all

all: $(DOCS_HTML_FILES)

$(DOCS_HTML_FILES): docs/%.html: tut/%.qmd
  ## create a docs directory if it does not already exits
	@mkdir -p $(DOCS_DIR)
	@echo "Compiling documentation for analyses"
	$(info Source = $<; Destination = $@)
	@echo $(notdir $@)
	$(eval PUBLIC_DIR = $(DOCS_DIR))
	echo "library(quarto); quarto_render(\"$<\")" | R --no-save --no-restore;
	cp $(patsubst %.qmd, %.html, $<) $(patsubst %.qmd, %.html, $@)
