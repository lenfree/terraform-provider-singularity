PROJECT_NAME := terraform-provider-singularity
package = github.com/packetloop/$(PROJECT_NAME)

.PHONY: test
test: dep env
	HOST=$(HOST) TF_ACC=$(TF_ACC) go test -race -cover -v ./...

.PHONY: vendor
vendor: dep
	dep ensure

.PHONY: dep
dep:
	go get github.com/tcnksm/ghr
	go get github.com/mitchellh/gox
	go get github.com/golang/dep/cmd/dep

.PHONY: env
env:
ifndef HOST
	$(error HOST is not set)
endif

.PHONY: build
build: dep
	gox -output="./release/{{.Dir}}_{{.OS}}_{{.Arch}}" -os="linux windows darwin" -arch="amd64" .

.PHONY: build-local
build-local: dep
	go build -o examples/terraform-provider-singularity
