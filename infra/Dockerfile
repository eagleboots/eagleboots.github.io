FROM alpine:3.18

# Version por defecto de Terraform
ARG TERRAFORM_VERSION=1.10.5

RUN apk add --no-cache \
    curl \
    git \
    bash \
    openssh-client \
    shadow \
    ca-certificates

RUN curl -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip \
    && unzip terraform.zip \
    && mv terraform /usr/local/bin/ \
    && rm terraform.zip

WORKDIR /workspace

ENTRYPOINT ["/usr/local/bin/terraform"]
