FROM registry.access.redhat.com/ubi9/ubi

RUN dnf install -y podman fuse-overlayfs && dnf clean all

RUN useradd -u 1000 -m podman && \
    mkdir -p /home/podman/.config/containers && \
    printf '[storage]\ndriver = "overlay"\n\n[storage.options.overlay]\nmount_program = "/usr/bin/fuse-overlayfs"\n' \
      > /home/podman/.config/containers/storage.conf && \
    chown -R 1000:1000 /home/podman

ENV HOME=/home/podman

LABEL com.redhat.component="registry-proxy-tests" \
      description="Registry proxy test suite for Quay.io" \
      distribution-scope="public" \
      io.k8s.description="Registry proxy test suite for Quay.io" \
      release="1" \
      url="https://github.com/quay/registry-proxy-tests" \
      vendor="Red Hat, Inc." \
      name="registry-proxy-tests"

# Copy the test script
COPY test-sigstore.sh /test-sigstore.sh
RUN chmod +x /test-sigstore.sh

COPY test-pull.sh /test-pull.sh
RUN chmod +x /test-pull.sh

COPY execute.sh /execute.sh
RUN chmod +x /execute.sh

ENTRYPOINT ["/execute.sh"]
