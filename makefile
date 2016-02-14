build:
	npm i --no-progress && elm package install && gulp
	
.PHONY: build
