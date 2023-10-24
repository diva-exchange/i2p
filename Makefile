TAG := ugosan/i2p:2.50.0-beta

ARM_TAG := $(TAG)-manifest-arm64v8
AMD_TAG := $(TAG)-manifest-amd64

all: build push pull

build:
	@echo "\n::: Building $(ARM_TAG)"
	docker build --push -f Dockerfile --platform linux/arm64/v8 --tag $(ARM_TAG) .
	@echo "\n::: Building $(AMD_TAG)"
	docker build --push -f Dockerfile --platform linux/amd64 --tag $(AMD_TAG) .
	docker manifest create $(TAG) --amend $(ARM_TAG) --amend $(AMD_TAG)
	@echo "\n::: Building done!"

push:
	docker manifest push $(TAG) --purge

pull:
	docker pull $(TAG)

