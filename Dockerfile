FROM hashicorp/terraform:0.11.13

# Install dependencies.
RUN apk add --no-cache \
  bash \
  git \
  go \
  make \
  musl-dev \
  openssl \
  python

# Install Google Cloud SDK (latest version).
RUN curl -sSL https://sdk.cloud.google.com | bash -s -- --disable-prompts
ENV PATH "~/google-cloud-sdk/bin:$PATH"

# Install AWS CLI (latest version).
RUN curl -o /tmp/awscli-bundle.zip -SSL https://s3.amazonaws.com/aws-cli/awscli-bundle.zip && \
  unzip /tmp/awscli-bundle.zip -d /tmp && \
  /tmp/awscli-bundle/install -i /usr/aws -b /bin/aws

# Install AWS IAM authenticator.
RUN curl -o /bin/aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/aws-iam-authenticator && \
  chmod +x /bin/aws-iam-authenticator && \
  cp /bin/aws-iam-authenticator /bin/aws-iam-authenticator.exe

# Install kubectl (1.14.1). Latest stable version can be found at https://storage.googleapis.com/kubernetes-release/release/stable.txt.
RUN curl -o /bin/kubectl -sSL https://storage.googleapis.com/kubernetes-release/release/v1.14.1/bin/linux/amd64/kubectl && \
  chmod +x /bin/kubectl

# Install Helm (2.13.1).
RUN curl -sSL https://raw.githubusercontent.com/helm/helm/v2.13.1/scripts/get | bash

# Configure Go.
RUN mkdir -p /go
ENV GOPATH "/go"

# Install 3rd party Terraform Kubernetes plugin with the support for beta resources.
RUN mkdir -p $GOPATH/src/github.com/sl1pm4t && \
  cd $GOPATH/src/github.com/sl1pm4t && \
  git clone https://github.com/sl1pm4t/terraform-provider-kubernetes && \
  cd $GOPATH/src/github.com/sl1pm4t/terraform-provider-kubernetes && \
  make build && \
  mkdir -p /root/.terraform.d/plugins && \
  cp $GOPATH/bin/terraform-provider-kubernetes /root/.terraform.d/plugins

ENTRYPOINT []
