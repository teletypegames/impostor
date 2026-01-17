# -----------------------------------------
# Makefile – TIC-80 project builder
# Usage:
#   make build 
#   make import_assets
#   make watch
#   make export
# -----------------------------------------

PROJECT = impostor

ORDER      = $(PROJECT).inc
OUTPUT     = $(PROJECT).lua
OUTPUT_ZIP = $(PROJECT).html.zip
OUTPUT_TIC = $(PROJECT).tic

SRC_DIR    = inc
SRC        = $(shell sed 's|^|$(SRC_DIR)/|' $(ORDER))

ASSETS_DIR = assets
ASSET_TYPES = tiles sprites sfx music

all: build

build: import_assets $(OUTPUT)

$(OUTPUT): $(SRC) $(ORDER)
	@rm -f $(OUTPUT)
	@while read f; do \
		cat "$(SRC_DIR)/$$f" >> $(OUTPUT); \
		echo "\n" >> $(OUTPUT); \
	done < $(ORDER)

import_assets:
	@for t in $(ASSET_TYPES); do \
		for f in $(ASSETS_DIR)/$$t/*.png; do \
			[ -e "$$f" ] || continue; \
			echo "==> Importing $$f as $$t..."; \
			tic80 --cli --skip --fs=. --cmd="import $$t $$f & exit"; \
		done; \
	done

export: build
	tic80 --cli --skip --fs=. \
		--cmd="load $(OUTPUT) & save $(PROJECT) & export html $(PROJECT).html & exit"

watch:
	make build
	fswatch -o $(SRC_DIR) $(ORDER) $(ASSETS_DIR) | while read; do make build; done
