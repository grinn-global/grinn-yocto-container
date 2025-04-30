FROM ubuntu:22.04

LABEL org.opencontainers.image.title="grinn-yocto"
LABEL org.opencontainers.image.description="Grinn Yocto Image"

ENV LANG=en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    dumb-init \
    gawk \
    wget \
    git \
    diffstat \
    unzip \
    texinfo \
    build-essential \
    chrpath \
    socat \
    python3 \
    python3-pip \
    xz-utils \
    locales \
    cpio \
    sudo && \
    \
    locale-gen en_US.UTF-8 && \
    \
    echo 'dash dash/sh boolean false' | debconf-set-selections && \
    dpkg-reconfigure -f noninteractive dash && \
    \
    useradd -m -s /bin/bash yoctouser && \
    chmod 0440 /etc/sudoers.d/yoctouser && \
    \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY sudoers-yoctouser /etc/sudoers.d/yoctouser

USER yoctouser
WORKDIR /home/yoctouser

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/bin/bash"]
