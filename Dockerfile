# We need 2.9.2 to verify the Chrome MemoryInfo workaround: https://github.com/cleandart/react-dart/pull/280
# TODO remove the workaround as well as this config once SDK lower bound is >=2.9.3
FROM google/dart:2.9.2
RUN dart --version

# Expose env vars for git ssh access
ARG GIT_SSH_KEY
ARG KNOWN_HOSTS_CONTENT
# Install SSH keys for git ssh access
RUN mkdir /root/.ssh
RUN echo "$KNOWN_HOSTS_CONTENT" > "/root/.ssh/known_hosts"
RUN echo "$GIT_SSH_KEY" > "/root/.ssh/id_rsa"
RUN chmod 700 /root/.ssh/
RUN chmod 600 /root/.ssh/id_rsa
RUN echo "Setting up ssh-agent for git-based dependencies"
RUN eval "$(ssh-agent -s)" && \
	ssh-add /root/.ssh/id_rsa

# Don't allow the dart package to be updated via apt
RUN apt-mark hold dart

# Update image - required by aviary
RUN apt-get update -qq && \
    apt-get dist-upgrade -y && \
    apt-get autoremove -y && \
    apt-get clean all
# Install deps for Chrome install
RUN apt-get install -y \
	build-essential \
	curl \
	git \
	make \
	parallel \
	wget \
	&& rm -rf /var/lib/apt/lists/*

# Chrome install taken from https://github.com/Workiva/dart_unit_test_image/blob/master@%7B13-01-2021%7D/Dockerfile

# Set the expected Chrome major version. This allows us to update the expected version when
# we need to roll out a new version of this base image with a new chrome version as the only change
ENV EXPECTED_CHROME_VERSION=87

# Install Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list && \
    apt-get -qq update && apt-get install -y google-chrome-stable && \
    mv /usr/bin/google-chrome-stable /usr/bin/google-chrome && \
    sed -i --follow-symlinks -e 's/\"\$HERE\/chrome\"/\"\$HERE\/chrome\" --no-sandbox/g' /usr/bin/google-chrome

# Fail the build if the version doesn't match what we expected
RUN google-chrome --version | grep " $EXPECTED_CHROME_VERSION\."

WORKDIR /build/
ADD . /build/

RUN pub get
# Run DDC tests to verify Chrome workaround
RUN pub run build_runner test -- --preset dartdevc

ARG BUILD_ARTIFACTS_AUDIT=/build/pubspec.lock
FROM scratch
