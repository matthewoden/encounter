build:
	npm i --no-progress && elm package install && npm run start

.PHONY: build
