[![Build status](https://circleci.com/gh/packetloop/terraform-provider-singularity.svg?style=shield&circle-token=:circle-token)](https://circleci.com/gh/packetloop/terraform-provider-singularity)
[![GitHub release](https://img.shields.io/github/release/packetloop/terraform-provider-singularity.svg)](https://github.com/packetloop/terraform-provider-singularity/releases/)
[![All Contributors](https://img.shields.io/github/contributors/packetloop/terraform-provider-singularity.svg?longCache=true&style=flat-square&colorB=orange&label=all%20contributors)](#contributors)
[![Github All Releases](https://img.shields.io/github/downloads/packetloop/terraform-provider-singularity/total.svg)]()


# terraform-provider-singularity

A terraform provider to manage Mesos hubspot/Singularity objects.

## Usage:

Download this provider, pick a version you'd like from releases from
[Binary Releases](https://github.com/packetloop/terraform-provider-singularity/releases)

Terraform version >= 0.12 is required.

```bash
curl -L \
  https://github.com/packetloop/terraform-provider-singularity/releases/download/v1.0.0/terraform-provider-singularity_v1.0.0_Darwin_x86_64 \
  -o ~/.terraform.d/plugins/terraform-provider-singularity_v1.0.0 && \
  chmod +x ~/.terraform.d/plugins/terraform-provider-singularity_v1.0.0
```

```bash
provider "singularity" {
  host    = "localhost"
  port    = 443
  version = "~> 1.0.0"
}

resource "singularity_request" "lenfree-demand" {
  request_id   = "sample-request"
  request_type = "ON_DEMAND"
}

resource "singularity_docker_deploy" "test-deploy" {
  cpu              = 2
  memory           = 128
  command          = "bash"
  args             = ["-xc", "date"]
  request_id       = "${singularity_request.lenfree-demand.id}"

  container_info {
    docker_info {
     force_pull_image = false
     network          = "BRIDGE"
     image            = "golang:latest"

     port_mapping {
       host_port           = 0
       container_port      = 10001
       container_port_type = "LITERAL"
       host_port_type      = "FROM_OFFER"
       protocol            = "tcp"
      }
    }
  }
}
```

More examples can be found in examples/main.tf.

## Import Resources:

Syntax

```
 terraform import singularity_request.lenfree-run <resource ID>
 terraform import singularity_docker_deploy.test-deploy-2 <resource ID>
```

## Development:

```bash
$ git clone git@github.com:packetloop/terraform-provider-singularity.git

# Run unit tests
$ make test

# Run end to end tests with a running Singularity service endpoint
$ HOST=localhost/singularity PORT=443  TF_ACC=1  go test -race -cover -v ./...
```

## Create a release:

```bash
# This will create a tag with prefix v and push to upstream master branch. CircleCI will then
# build and create a release of this tag.
$ make create-tag=0.1.3
```
