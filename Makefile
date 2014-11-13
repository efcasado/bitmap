###========================================================================
### File: Makefile
###
### Author: Enrique Fernandez <efcasado@gmail.com>
###
###-- LICENSE -------------------------------------------------------------
### The MIT License (MIT)
###
### Copyright (c) 2014 Enrique Fernandez
###
### Permission is hereby granted, free of charge, to any person obtaining
### a copy of this software and associated documentation files (the
### "Software"), to deal in the Software without restriction, including
### without limitation the rights to use, copy, modify, merge, publish,
### distribute, sublicense, and/or sell copies of the Software,
### and to permit persons to whom the Software is furnished to do so,
### subject to the following conditions:
###
### The above copyright notice and this permission notice shall be included
### in all copies or substantial portions of the Software.
###
### THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
### EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
### MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
### IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
### CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
### TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
### SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
###========================================================================
.PHONY: compile clean $(EBIN_DIR)

## ========================================================================
##  Configuration
## ========================================================================

PROJECT_NAME   := bitmap

ERL            := $(shell which erl)
ERLC           := $(shell which erlc)
ERLC_OPTS      := -pz ebin

SRC_DIR        := src
EBIN_DIR       := ebin
TEST_DIR       := tests

SRC_FILES      := $(notdir $(shell find $(SRC_DIR) -name "*.erl"))
BIN_FILES      := $(patsubst %.erl,$(EBIN_DIR)/%.beam,$(SRC_FILES))
TEST_FILES     := $(notdir $(shell find $(TEST_DIR) -name "*.erl"))
BIN_TEST_FILES := $(patsubst %.erl,%.beam,$(TEST_FILES))

VPATH = $(SRC_DIR) $(TEST_DIR)

## ========================================================================
##  Targets
## ========================================================================

compile: $(EBIN_DIR) ebin/$(PROJECT_NAME).app $(BIN_FILES) $(BIN_TEST_FILES)

$(EBIN_DIR):
	@[ -d $(EBIN_DIR) ] || mkdir -p $(EBIN_DIR)

ebin/$(PROJECT_NAME).app: $(PROJECT_NAME).app.src
	@echo "Generating app file"
	@cp $< $(EBIN_DIR)/$(PROJECT_NAME).app

# This rule is used to compile source files.
ebin/%.beam: %.erl
	@echo "Compiling module $(notdir $<)"
	@$(ERLC) $(ERLC_OPTS) -o ebin $<

# This rule is used to compile test files.
%.beam: %.erl
	@echo "Compiling test $(notdir $<)"
	@$(ERLC) $(ERLC_OPTS) -o $(dir $<) $<

clean:
	@rm -rf ebin
	$(shell find $(TEST_DIR) -name "*.beam" -delete)
