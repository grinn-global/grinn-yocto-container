FROM ubuntu:24.04

LABEL org.opencontainers.image.title="grinn-yocto"
LABEL org.opencontainers.image.description="Grinn Yocto Build Environment"
LABEL org.opencontainers.image.authors="Grinn <office@grinn-global.com>"
LABEL org.opencontainers.image.url="https://github.com/grinn-global/grinn-yocto-container"

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    DEBIAN_FRONTEND=noninteractive

COPY yoctouser /etc/sudoers.d/yoctouser

# https://docs.yoctoproject.org/ref-manual/system-requirements.html
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
        gawk \
        gcc \
        gcc-multilib \
        git \
        iputils-ping \
        iputils-ping \
        libacl1 \
        liblz4-tool \
        locales \
        locales \
        lsb-release \
        net-tools \
        python3 \
        python3-git \
        python3-jinja2 \
        python3-pexpect \
        python3-pip \
        python3-subunit \
        rsync \
        socat \
        sudo \
        texinfo \
        tzdata \
        unzip \
        vim-tiny \
        wget \
        xz-utils \
        zstd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    \
    sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen && \
    \
    chmod 0440 /etc/sudoers.d/yoctouser && \
    \
    userdel -r ubuntu && \
    useradd -m -s /bin/bash yoctouser && \
    usermod -aG sudo yoctouser && \
    \
    touch /home/yoctouser/.sudo_as_admin_successful && \
    sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' /home/yoctouser/.bashrc && \
    echo '\nexport PS1="🐢 $PS1"' >> /home/yoctouser/.bashrc

USER yoctouser
WORKDIR /home/yoctouser

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/bin/bash"]
