# Grinn Yocto Container

The `grinn-yocto-container` is a container image built on Ubuntu, specifically designed to support Yocto development. It comes preconfigured with essential build tools, libraries, and settings required to efficiently compile Yocto-based projects.

## Prerequisites

Ensure that Docker is installed on your system by following the official [setup guide](https://docs.docker.com/get-docker/). Alternatively, Podman can be used as a drop-in replacement for Docker. Installation instructions are available [here](https://podman.io/getting-started/installation). To use Podman, simply replace `docker` with `podman` in the commands provided in this document.

## Building the Container

To build the container image, clone this repository and navigate to the directory containing the Dockerfile. Then, run the following command:

```bash
docker build -t grinn-yocto-container .
```

## Pulling the Pre-built Container

If you prefer not to build the container yourself, you can pull a pre-built version from the GitHub Container Registry:

```bash
docker pull ghcr.io/grinn-global/grinn-yocto-container
```

This command will download the latest version of the container image, which is maintained and updated by the Grinn team.

## Running the Container

The container can be run interactively with a bash shell using the following command:

```bash
docker run -it grinn-yocto-container
```

This will start the container with a bash shell, where you can begin using the Yocto development tools. The environment is pre-configured with a user `yoctouser`, who has sudo privileges. This user can be utilized to carry out any required installations or system configurations.

### Volume Mounting

To mount a local directory into the container, use the `-v` option:

```bash
mkdir ws
docker run -it -v ./ws:/home/yoctouser/ws grinn-yocto-container
```

This allows you to work on your Yocto projects directly from your local machine while utilizing the container's environment.

By default, the `yoctouser` has UID 1000 and GID 1000, which is the same as the default user on most Linux distributions. This means that files created in the mounted directory will retain the same ownership and permissions as they would outside the container. However, if you need to run the container with a different user or group ID, you can specify them using the `CUSTOM_UID` and `CUSTOM_GID` environment variables. For example, to run the container with a user ID of 1004 and a group ID of 2000, use the following command:

```bash
docker run -it \
    -e CUSTOM_UID=1004 \
    -e CUSTOM_GID=2000 \
    -v ./ws:/home/yoctouser/ws \
    grinn-yocto-container
```

### SSH Agent Forwarding

To enable SSH agent forwarding, which allows you to use your local SSH keys inside the container, you can pass the SSH agent socket to the container. This is useful for accessing private repositories or remote servers from within the container.

Ensure that your SSH agent is running on your host machine and then run the container with the following command:

```bash
docker run -it \
    -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
    -v $SSH_AUTH_SOCK:$SSH_AUTH_SOCK:ro \
    grinn-yocto-container
```
