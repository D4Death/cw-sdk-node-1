SHELL := /bin/bash

proto_module := src/modules/proto
version_file := src/version.ts

build: src/modules ## Build project
	rm -rf build
	npm run build

src/modules: ${proto_module} ${version_file} ## Generate typescript definition files

# Generate typescript definitions for our protobuf messages
${proto_module}: node_modules
	mkdir -p ${proto_module}
	# Generate static module
	./node_modules/protobufjs/bin/pbjs -t static-module -w commonjs -o index.tmp.js \
		proto/{client,markets,stream,broker}/*.proto
	echo "/* Generated by Makefile */" > ${proto_module}/index.js
	echo "/* tslint:disable */" >> ${proto_module}/index.js
	cat index.tmp.js >> ${proto_module}/index.js
	rm index.tmp.js
	# Generate definition files
	./node_modules/protobufjs/bin/pbjs \
		-t static-module proto/{client,markets,stream,broker}/*.proto \
		| ./node_modules/protobufjs/bin/pbts -o proto.d.ts -
	# Add some stuff to the top of the file and rename it
	echo "/* Generated by Makefile */" > ${proto_module}/index.d.ts
	echo "/* tslint:disable */" >> ${proto_module}/index.d.ts
	cat proto.d.ts >> ${proto_module}/index.d.ts
	rm proto.d.ts

# Generate a version.ts file that exports the current version of the app
${version_file}:
	PACKAGE_VERSION=$$(node -p -e "require('./package.json').version") ; \
									echo "/* This code was generated by Makefile: \"make set_version_file\" */" > ${version_file} ; \
									echo "const version = \"$$PACKAGE_VERSION\";" >> ${version_file} ; \
									echo "export default version;" >> ${version_file}


test: lint test-modules test-diff test-package ## Shortcut to run all tests

lint: node_modules ## Run linter
	npm run lint

test-modules: node_modules ## Test package modules
	timeout -k 5s 150s npm run test

test-diff: build ## Tests if dist is up-to-date
	@TMP=$$(mktemp -t checkout-diff.XXXXXX) ; \
		git diff build/ > $$TMP ; \
		if [ -s "$$TMP" ]; then \
		echo Found diffs in checkout:; git status -s; head -n 50 "$$TMP"; \
		rm $$TMP; \
		echo; \
		echo 'Try running "make"'; \
		echo; \
		exit 1; \
		fi; \
		rm $$TMP;

test-package: build ## Tests packaged npm module
	npm pack
	@PACK=$$(find . -name cw-sdk-node* | xargs basename $1) ; \
		TMP=$$(mktemp -d -t package-test.XXXXXX) ; \
		echo $$TMP ; \
		echo $$PACK ; \
		echo mv $$PACK $$TMP ; \
		mv $$PACK $$TMP ; \
		cp test/package/package.json $$TMP ; \
		cp test/package/index.js $$TMP ; \
		cd $$TMP ; \
		npm i $$PACK ; \
		node . ; \
		if ! node .; then \
		rm -rf $$TMP ; \
		exit 1; \
		fi; \
		rm -rf $$TMP

node_modules:
	yarn

clean: ## Remove generated files
	rm -rf node_modules build

help: ## Show help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build \
				test \
				lint \
				test-diff \
				test-modules \
				test-package