FROM ubuntu:24.04

LABEL org.opencontainers.image.title="grinn-yocto"
LABEL org.opencontainers.image.description="Grinn Yocto Build Environment"
LABEL org.opencontainers.image.authors="Grinn <office@grinn-global.com>"
LABEL org.opencontainers.image.url="https://github.com/grinn-global/grinn-yocto-container"

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
        zstd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    \
    sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen && \
    \
    userdel -r ubuntu && \
    useradd -m -s /bin/bash yoctouser && \
    usermod -aG sudo yoctouser && \
    \
    install-yocto-buildtools.sh 4.3.4 0fd353011183ef3b046da152fcdc587142cff5e63aa35fbd7229af9d3cb1cb06

USER yoctouser
WORKDIR /home/yoctouser

RUN touch .sudo_as_admin_successful && \
    sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' .bashrc && \
    sed -i "/^#export GCC_COLORS=/s/^#//" ~/.bashrc && \
    echo '\nexport PS1="🐢 $PS1"' >> .bashrc && \
    echo '\n. /opt/poky/4.3.4/environment-setup-x86_64-pokysdk-linux' >> .bashrc

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/bin/bash"]
