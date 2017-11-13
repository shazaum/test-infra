PROJECT ?= istio-testing
VERSION ?= 0.4.5-bazel7-go19

# Note: The build directory is the root of the istio/test-infra repository, not ./
image:
	docker build -t istio-builder -f istio_builder/Dockerfile ../../
	docker tag istio-builder gcr.io/$(PROJECT)/istio-builder:$(VERSION)
	docker tag istio-builder gcr.io/$(PROJECT)/istio-builder:latest
	docker build -t gcr.io/$(PROJECT)/prow-builder:$(VERSION) -f prow_builder/Dockerfile ../..

# Build local istio-builder
builder:
	docker build -t istio-builder -f istio_builder/Dockerfile ../../
	docker tag istio-builder gcr.io/$(PROJECT)/istio-builder:$(VERSION)

# Push only the versioned image. Latest will be kept to previous version
push_builder: builder
	gcloud docker -- push "gcr.io/$(PROJECT)/istio-builder:$(VERSION)"

push:
	gcloud docker -- push "gcr.io/$(PROJECT)/istio-builder:latest"
	gcloud docker -- push "gcr.io/$(PROJECT)/istio-builder:$(VERSION)"
	gcloud docker -- push "gcr.io/$(PROJECT)/prow-builder:$(VERSION)"


.PHONY: image push
