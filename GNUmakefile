PYTHON3                                 := $(shell which python3)
export PYTHON3
PORT:=8000

.PHONY: serve build
init:
	python3 -m pip install -r requirements.txt
build:
	mkdocs build
serve: build
	mkdocs serve & open 127.0.0.1:$(PORT)
	#$(PYTHON3) -m http.server $(PORT) --bind 127.0.0.1 -d $(PWD)/docs > /dev/null 2>&1 || open http://127.0.0.1:$(PORT)