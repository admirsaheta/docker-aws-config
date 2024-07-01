FROM --platform=linux/amd64 node:20.10.0

# Install necessary tools
RUN apt-get update && apt-get install -y \
    zip \
    curl \
    gnupg \
    wget \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && aws --version

# Install jq
ENV JQ_VERSION='1.6'
RUN wget --no-check-certificate https://raw.githubusercontent.com/stedolan/jq/jq-${JQ_VERSION}/sig/jq-release.key -O /tmp/jq-release.key \
    && wget --no-check-certificate https://raw.githubusercontent.com/stedolan/jq/jq-${JQ_VERSION}/sig/v${JQ_VERSION}/jq-linux64.asc -O /tmp/jq-linux64.asc \
    && wget --no-check-certificate https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 -O /tmp/jq-linux64 \
    && gpg --import /tmp/jq-release.key \
    && gpg --verify /tmp/jq-linux64.asc /tmp/jq-linux64 \
    && cp /tmp/jq-linux64 /usr/bin/jq \
    && chmod +x /usr/bin/jq \
    && rm -f /tmp/jq-release.key \
    && rm -f /tmp/jq-linux64.asc \
    && rm -f /tmp/jq-linux64

# Install helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

CMD ["node"]
