FROM hashicorp/terraform:0.12.3

# Install dependencies.
RUN apk add --no-cache \
  bash \
  curl \
  git \
  go \
  make \
  musl-dev \
  openssl \
  python

# Install Google Cloud SDK (latest version).
RUN curl -sSL https://sdk.cloud.google.com | bash -s -- --disable-prompts
ENV PATH "~/google-cloud-sdk/bin:$PATH"

# Install AWS CLI (latest version). Latest version information can be found at https://github.com/aws/aws-cli/blob/master/CHANGELOG.rst.
RUN curl -o /tmp/awscli-bundle.zip -SSL https://s3.amazonaws.com/aws-cli/awscli-bundle.zip && \
  unzip /tmp/awscli-bundle.zip -d /tmp && \
  /tmp/awscli-bundle/install -i /usr/aws -b /bin/aws

# Install AWS IAM authenticator. Latest stable version can be found at https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html.
RUN curl -o /bin/aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.13.7/2019-06-11/bin/linux/amd64/aws-iam-authenticator && \
  chmod +x /bin/aws-iam-authenticator && \
  cp /bin/aws-iam-authenticator /bin/aws-iam-authenticator.exe

# Install kubectl (1.15.0). Latest stable version can be found at https://storage.googleapis.com/kubernetes-release/release/stable.txt.
RUN curl -o /bin/kubectl -sSL https://storage.googleapis.com/kubernetes-release/release/v1.15.0/bin/linux/amd64/kubectl && \
  chmod +x /bin/kubectl

# Install Helm (2.14.1).
ENV DESIRED_VERSION=v2.14.1
RUN curl -sSL https://raw.githubusercontent.com/helm/helm/master/scripts/get | bash

# Configure Go.
RUN mkdir -p /go
ENV GOPATH "/go"

# Install 3rd party Terraform Kubernetes plugin with the support for beta resources.
RUN mkdir -p $GOPATH/src/github.com/sl1pm4t && \
  cd $GOPATH/src/github.com/sl1pm4t && \
  git clone https://github.com/sl1pm4t/terraform-provider-kubernetes && \
  cd $GOPATH/src/github.com/sl1pm4t/terraform-provider-kubernetes && \
  make fmt && \
  make build && \
  mkdir -p /root/.terraform.d/plugins && \
  cp $GOPATH/bin/terraform-provider-kubernetes /root/.terraform.d/plugins

ENTRYPOINT []
