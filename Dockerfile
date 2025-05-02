FROM ubuntu:22.04

ARG VERSION=0.1.0
ARG BUILDTOOLS_VERSION=4.0.26
ARG BUILDTOOLS_SHA256=6938ec21608f6152632093f078a8d30eb2a7c9efa686e373f907a1b907e7be47

LABEL org.opencontainers.image.title="grinn-yocto-container" \
    org.opencontainers.image.ref.name="grinn-yocto-container" \
    org.opencontainers.image.description="Grinn Yocto Build Environment" \
    org.opencontainers.image.version="${VERSION}" \
    org.opencontainers.image.authors="Grinn <office@grinn-global.com>" \
    org.opencontainers.image.url="https://github.com/grinn-global/grinn-yocto-container" \
    org.opencontainers.image.source="https://github.com/grinn-global/grinn-yocto-container" \
    org.opencontainers.image.licenses="MIT"

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    DEBIAN_FRONTEND=noninteractive

COPY --chmod=0440 yoctouser /etc/sudoers.d/yoctouser
COPY --chmod=0755 install-yocto-buildtools.sh /usr/local/bin/install-yocto-buildtools.sh

# https://docs.yoctoproject.org/ref-manual/system-requirements.html#ubuntu-and-debian
RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        bash-completion \
        build-essential \
        chrpath \
        command-not-found \
        cpio \
        curl \
        debianutils \
        diffstat \
        dumb-init \
        file \
        g++-multilib \
        gawk \
        gcc \
        gcc-multilib \
        git \
        iputils-ping \
        libacl1 \
        liblz4-tool \
        locales \
        lsb-release \
        net-tools \
        python3 \
        python3-git \
        python3-jinja2 \
        python3-pexpect \
        python3-pip \
        python3-subunit \
        python3-virtualenv \
        rsync \
        socat \
        sudo \
        texinfo \
        tzdata \
        unzip \
        vim-tiny \
        wget \
        xz-utils \
        zstd \
        \
        debianutils \
        libegl1-mesa \
        libelf-dev \
        libsdl1.2-dev \
        libstdc++-12-dev \
        lz4 \
        mesa-common-dev \
        pylint && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    \
    sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen && \
    \
    useradd -m -s /bin/bash yoctouser && \
    usermod -aG sudo yoctouser && \
    \
    install-yocto-buildtools.sh "${BUILDTOOLS_VERSION}" "${BUILDTOOLS_SHA256}"

USER yoctouser
WORKDIR /home/yoctouser

RUN touch .sudo_as_admin_successful && \
    sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' .bashrc && \
    sed -i "/^#export GCC_COLORS=/s/^#//" ~/.bashrc && \
    printf '\n%s\n' 'export PS1="🐢 $PS1"' >> .bashrc && \
    printf '\n%s\n' ". /opt/poky/${BUILDTOOLS_VERSION}/environment-setup-x86_64-pokysdk-linux" >> .bashrc

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/bin/bash"]
