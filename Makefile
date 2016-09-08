NPM_TOKEN ?= '00000000-0000-0000-0000-000000000000'
CI_BUILD_NUMBER ?= $(USER)-snapshot
VERSION ?= 0.2.$(CI_BUILD_NUMBER)
BUILDER_TAG = "node:6"
CI_WORKDIR ?= $(shell pwd)

package:
	@docker pull $(BUILDER_TAG)
	@docker run \
		-t \
		-e NPM_TOKEN=$(NPM_TOKEN) \
		-v $(CI_WORKDIR):/usr/src/app \
		-w /usr/src/app \
		$(BUILDER_TAG) \
		make __package-node

publish:
	@docker pull $(BUILDER_TAG)
	@docker run \
	  -t \
		-e NPM_TOKEN=$(NPM_TOKEN) \
		-v $(CI_WORKDIR):/usr/src/app \
		-w /usr/src/app \
		$(BUILDER_TAG) \
		make __publish-node

__package-node:
	@npm install
	@npm test
	@npm prune --production

__publish-node: __package-node
	@echo "//registry.npmjs.org/:_authToken=$(NPM_TOKEN)" > ~/.npmrc
	@npm publish

__version:
	@echo $(VERSION)
