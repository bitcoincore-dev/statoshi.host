PYTHON3                                 := $(shell which python3)
export PYTHON3
PORT:=2323

.PHONY: serve build
build:
	mkdocs build
serve: build
	$(PYTHON3) -m http.server $(PORT) --bind 127.0.0.1 -d $(PWD)/docs > /dev/null 2>&1 || open http://127.0.0.1:$(PORT)