FROM hashicorp/terraform:1.3.3

# Install dependencies.
RUN apk add --no-cache --update \
  bash \
  curl \
  jq \
  openssl \
  python3 \
  && ln -s `which python3` /bin/python

# Install build dependencies.
# Ref: https://github.com/sgerrand/alpine-pkg-glibc/releases
RUN apk add --no-cache --virtual build_tools \
  binutils \
  gnupg-dirmngr \
  gpgme \
  && curl -sSL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
  && curl -sSLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r0/glibc-2.35-r0.apk \
  && curl -sSLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r0/glibc-bin-2.35-r0.apk \
  && curl -sSLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r0/glibc-i18n-2.35-r0.apk \
  && apk add --no-cache \
  glibc-2.35-r0.apk \
  glibc-bin-2.35-r0.apk \
  glibc-i18n-2.35-r0.apk \
  && /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 \
  && ln -sf /usr/glibc-compat/lib/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2

# Install Terragrunt (0.39.2). Ref: https://github.com/gruntwork-io/terragrunt/releases
ENV TERRAGRUNT_VERSION v0.39.2
ADD https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 /bin/
RUN mv /bin/terragrunt_linux_amd64 /bin/terragrunt \
  && chmod u+x /bin/terragrunt

# Install Google Cloud SDK (latest version). Ref: https://cloud.google.com/sdk/docs/release-notes
RUN curl -sSL https://sdk.cloud.google.com | bash -s -- --disable-prompts
RUN ~/google-cloud-sdk/bin/gcloud components update
ENV PATH "~/google-cloud-sdk/bin:$PATH"

# Install AWS CLI (latest version). Ref https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst
ADD https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip /tmp/
RUN unzip /tmp/awscli-exe-linux-x86_64.zip -d /tmp \
  && /tmp/aws/install \
  && rm -rf \
  /usr/local/aws-cli/v2/*/dist/aws_completer \
  /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
  /usr/local/aws-cli/v2/*/dist/awscli/examples \
  glibc-*.apk

# Install AWS IAM authenticator. Ref https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
RUN curl -Lo /usr/bin/aws-iam-authenticator https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.5.9/aws-iam-authenticator_0.5.9_linux_amd64
RUN chmod u+x /usr/bin/aws-iam-authenticator \
  && cp /usr/bin/aws-iam-authenticator /usr/bin/aws-iam-authenticator.exe

# Install HashiCorp Vault. Ref: https://www.vaultproject.io/downloads
ENV VAULT_VERSION 1.12.0
ENV VAULT_GPGKEY C874011F0AB405110D02105534365D9472D7468F
ADD https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip /tmp/
ADD https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS /tmp/
ADD https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS.sig /tmp/
RUN cd /tmp \
  && gpg --keyserver keyserver.ubuntu.com --recv-key "${VAULT_GPGKEY}" \
  && gpg --verify /tmp/vault_${VAULT_VERSION}_SHA256SUMS.sig \
  && cat /tmp/vault_${VAULT_VERSION}_SHA256SUMS | grep linux_amd64 | sha256sum -c \
  && unzip /tmp/vault_${VAULT_VERSION}_linux_amd64.zip -d /usr/bin \
  && cd -

# Install kubectl (v1.25.3). Ref https://storage.googleapis.com/kubernetes-release/release/stable.txt
ENV KUBECTL_VERSION v1.25.3
ADD https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl /usr/bin/
RUN chmod u+x /usr/bin/kubectl

# Install Helm (3.10.1). Version histroy can be found at https://github.com/helm/helm/tags
ENV DESIRED_VERSION v3.10.1
RUN curl -sSL https://raw.githubusercontent.com/helm/helm/master/scripts/get | bash \
  && helm repo add stable https://charts.helm.sh/stable

# Cleanup.
RUN apk del build_tools \
  && rm -rf /tmp/* \
  && rm -rf /var/cache/apk/*

ENTRYPOINT []
