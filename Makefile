# -----------------------------------------
# Makefile – TIC-80 project builder
# -----------------------------------------

PROJECT = impostor

ORDER      = $(PROJECT).inc
OUTPUT     = $(PROJECT).lua
OUTPUT_ZIP = $(PROJECT).html.zip
OUTPUT_TIC = $(PROJECT).tic

SRC_DIR    = inc
SRC        = $(shell sed 's|^|$(SRC_DIR)/|' $(ORDER))

ASSETS_LUA = inc/meta/meta.assets.lua

all: build

build: $(OUTPUT)

$(OUTPUT): $(SRC) $(ORDER)
	@rm -f $(OUTPUT)
	@while read f; do \
		cat "$(SRC_DIR)/$$f" >> $(OUTPUT); \
		echo "" >> $(OUTPUT); \
	done < $(ORDER)

import_assets:
	@for t in $(ASSET_TYPES); do \
		for f in $(ASSETS_DIR)/$$t/*.png; do \
			[ -e "$$f" ] || continue; \
			echo "==> Importing $$f as $$t..."; \
			tic80 --cli --skip --fs=. --cmd="import $$t $$f & exit"; \
		done; \
	done

export_assets: build
	@echo "==> Exporting TIC-80 asset sections"
	@mkdir -p inc/meta
	@sed -n '/^-- <PALETTE>/,/^-- <\/PALETTE>/p;\
	         /^-- <TILES>/,/^-- <\/TILES>/p;\
	         /^-- <SPRITES>/,/^-- <\/SPRITES>/p;\
	         /^-- <MAP>/,/^-- <\/MAP>/p;\
	         /^-- <SFX>/,/^-- <\/SFX>/p;\
	         /^-- <MUSIC>/,/^-- <\/MUSIC>/p' \
		$(OUTPUT) > $(ASSETS_LUA)

export: build
	tic80 --cli --skip --fs=. \
		--cmd="load $(OUTPUT) & save $(PROJECT) & export html $(PROJECT).html & exit"

watch:
	make build
	fswatch -o $(SRC_DIR) $(ORDER) assets | while read; do make build; done
