# Terraform Docker Container with Google Cloud SDK and AWS CLI tools

## Usage

This repository features the Docker container for using the terraform command line program. It's based on the [Official HashiCorp Docker Image](https://hub.docker.com/r/hashicorp/terraform) and has AWS CLI, Google Cloud SDK, and other tools for Kubernetes deployments bundled in.

## Features

- [X] Terraform 0.12.3
- [X] Google Cloud SDK 252.0.0
- [X] AWS CLI 1.16.190 + aws-iam-authenticator
- [X] kubectl 1.15.0
- [X] Helm 2.14.1
- [X] Go 1.11.5-r0
- [X] [3rd-party Kubernetes Terraform Provider](https://github.com/sl1pm4t/terraform-provider-kubernetes) with the support for additional Kubernetes resources
