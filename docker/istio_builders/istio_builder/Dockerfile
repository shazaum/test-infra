FROM ubuntu:xenial

# Note: The build directory is the root of the istio/test-infra repo, not ./

# Installing necessary packages
RUN rm -rf /var/lib/apt/lists/* \
    && apt-get update --fix-missing  \
    && apt-get install -y git iptables procps sudo xz-utils

# Adding sudo group user no password access.
# This is used by bootstrap user to start docker service
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Installing deps. See scripts/tools/linux-install-COMPONENT
ADD scripts /tmp/istio_tmp/scripts
RUN chmod +x /tmp/istio_tmp/scripts/linux-install-software
RUN /tmp/istio_tmp/scripts/linux-install-software \
    && rm -rf /tmp/istio_tmp

ENV PATH /usr/local/go/bin:/usr/lib/google-cloud-sdk/bin:/opt/go/bin:${PATH}
RUN echo "PATH=\"${PATH}\"" > /etc/environment

# Add entrypoint that runs bootstrap with appropriate arguments
ADD docker/istio_builders/istio_builder/entrypoint.sh /usr/local/bin/entrypoint
RUN sudo chmod +rx /usr/local/bin/entrypoint

RUN touch /etc/passwd && chmod a+rw /etc/passwd

# FPM - used to create multiple packages
RUN apt-get update \
  && apt-get -qqy install ruby ruby-dev rubygems build-essential
RUN  gem install --no-ri --no-rdoc fpm pleaserun

# Install kubectl and minikube
RUN curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/v1.7.4/bin/linux/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/ \
   curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.22.3/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/

# Add a default user and group
RUN addgroup --gid 1000 istio-builder
RUN adduser --home /workspace --uid 1000 --gid 1000 istio-builder

ENTRYPOINT ["entrypoint"]
