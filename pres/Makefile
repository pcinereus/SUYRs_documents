PRES_SRC_DIR  = $(addprefix , pres)
ifdef FILE
PRES_FILES = $(PRES_SRC_DIR)/$(FILE)
else
PRES_FILES ?= $(foreach sdir, $(PRES_SRC_DIR), $(wildcard $(sdir)/*.qmd))
endif

HTML_FILES := $(patsubst %.qmd, %.html, $(PRES_FILES))
PUBLIC_DIR := public/
# DOCS_DIR   := $(addprefix , ./)
DOCS_DIR   := $(addprefix , docs/)
DOCS_HTML_FILES := $(patsubst $(PRES_SRC_DIR)/%.qmd, $(DOCS_DIR)%.html, $(PRES_FILES))
FILES := $(patsubst $(PRES_SRC_DIR)/%.qmd, %.html, $(PRES_FILES))

$(info ************************************)
$(info PRES Source directory:     $(PRES_SRC_DIR))
$(info PRES Source files:         $(PRES_FILES))
$(info PRES HTML files:           $(HTML_FILES))
$(info DOC HTML files:           $(DOCS_HTML_FILES))
$(info PUBLIC_DIR:              $(PUBLIC_DIR))
$(info DOCS_DIR:              $(DOCS_DIR))
$(info FILES:                 $(FILES))
$(info ************************************)

.PHONY: all

all: $(DOCS_HTML_FILES)

$(DOCS_HTML_FILES): docs/%.html: pres/%.qmd
  ## create a docs directory if it does not already exits
	@mkdir -p $(DOCS_DIR)
	@echo "Compiling documentation for analyses"
	$(info Source = $<; Destination = $@)
	@echo $(notdir $@)
	$(eval PUBLIC_DIR = $(DOCS_DIR))
	echo "library(quarto); quarto_render(\"$<\", output_format = 'revealjs')" | R --no-save --no-restore;
	@echo ls -la
	cp $(patsubst %.qmd, %.html, $<) $(patsubst %.qmd, %.html, $@)
