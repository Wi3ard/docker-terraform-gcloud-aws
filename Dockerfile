FROM hashicorp/terraform:0.12.24

# Install dependencies.
RUN apk add --no-cache \
  bash \
  curl \
  openssl \
  python

# Install Google Cloud SDK (latest version).
RUN curl -sSL https://sdk.cloud.google.com | bash -s -- --disable-prompts
ENV PATH "~/google-cloud-sdk/bin:$PATH"

# Install AWS CLI (latest version). Latest version information can be found at https://github.com/aws/aws-cli/blob/master/CHANGELOG.rst
RUN curl -o /tmp/awscli-bundle.zip -SSL https://s3.amazonaws.com/aws-cli/awscli-bundle.zip && \
  unzip /tmp/awscli-bundle.zip -d /tmp && \
  /tmp/awscli-bundle/install -i /usr/aws -b /bin/aws

# Install AWS IAM authenticator. Latest stable version can be found at https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
RUN curl -o /bin/aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.15.10/2020-02-22/bin/linux/amd64/aws-iam-authenticator && \
  chmod +x /bin/aws-iam-authenticator && \
  cp /bin/aws-iam-authenticator /bin/aws-iam-authenticator.exe

# Install kubectl (1.17.4). Latest stable version can be found at https://storage.googleapis.com/kubernetes-release/release/stable.txt
RUN curl -o /bin/kubectl -sSL https://storage.googleapis.com/kubernetes-release/release/v1.17.4/bin/linux/amd64/kubectl && \
  chmod +x /bin/kubectl

# Install Helm (3.1.2). Version histroy can be found at https://github.com/helm/helm/tags
ENV DESIRED_VERSION=v3.1.2
RUN curl -sSL https://raw.githubusercontent.com/helm/helm/master/scripts/get | bash

ENTRYPOINT []
