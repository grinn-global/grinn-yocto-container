# Grinn Yocto Container

The `grinn-yocto-container` is a container image built on Ubuntu, specifically designed to support Yocto development. It comes preconfigured with essential build tools, libraries, and settings required to efficiently compile Yocto-based projects.

## Prerequisites

Ensure that Docker is installed on your system by following the official installation guide [here](https://docs.docker.com/get-docker/).
Alternatively, Podman is also supported; installation instructions are available [here](https://podman.io/getting-started/installation).

## Building the Container

To build the container image, clone this repository and navigate to the directory containing the Dockerfile. Then, run the following command:

```bash
docker build -t grinn-yocto-container .
```
or if you are using Podman:

```bash
podman build -t grinn-yocto-container .
```

## Pulling the Pre-built Container

If you prefer not to build the container yourself, you can pull a pre-built version from the GitHub Container Registry. Use the following command:

```bash
docker pull ghcr.io/grinn-global/grinn-yocto-container
```
or if you are using Podman:

```bash
podman pull ghcr.io/grinn-global/grinn-yocto-container
```

This command will download the latest version of the container image, which is maintained and updated by the Grinn team.

## Running the Container

The container can be run interactively:

```bash
docker run -it grinn-yocto-container
```

This will start the container with a bash shell, where you can begin using the Yocto development tools.

## Usage

Upon entering the container, you will be greeted with a prompt, featuring a happy turtle icon. The environment is pre-configured with a user `yoctouser`, who has sudo privileges. This user can be utilized to carry out any required installations or system configurations.
