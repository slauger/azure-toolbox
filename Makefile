.DEFAULT_GOAL := build

CONTAINER_NAME?=quay.io/slauger/$(shell basename $(shell pwd))
CONTAINER_TAG?=latest
TAG_FROM?=latest

build:
	docker build -t $(CONTAINER_NAME):$(CONTAINER_TAG) .

test:
	docker run -v /var/run/docker.sock:/var/run/docker.sock -v $(shell pwd):/src:ro gcr.io/gcp-runtimes/container-structure-test:latest test --image $(CONTAINER_NAME):$(CONTAINER_TAG) --config /src/tests/container-structure-test.yaml

push:
	docker push $(CONTAINER_NAME):$(CONTAINER_TAG)

tag:
	docker tag $(CONTAINER_NAME):$(TAG_FROM) $(CONTAINER_NAME):$(TAG_TO)

run:
	mkdir -p workspace
	docker run --rm -it --mount type=bind,source="$(PWD)/workspace",target=/workspace --workdir /workspace --mount type=bind,source="$(HOME)/.ssh,target=/root/.ssh" -e HOME=/workspace $(CONTAINER_NAME):$(CONTAINER_TAG)
