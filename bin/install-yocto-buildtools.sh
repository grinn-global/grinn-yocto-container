#!/bin/sh

set -eu

RELEASE="$1"
SHA256SUM="$2"

if [ -z "$RELEASE" ] || [ -z "$SHA256SUM" ]; then
    echo "Usage: $0 <release> <sha256sum>"
    exit 1
fi

tmp_dir=$(mktemp -d -t buildtools_installer-XXXX)
trap 'rm -rf -- "$tmp_dir"' EXIT INT TERM
cd "$tmp_dir"

echo "Downloading Yocto Buildtools for release ${RELEASE}..."
buildtools_installer="x86_64-buildtools-extended-nativesdk-standalone-${RELEASE}.sh"
wget --quiet "https://downloads.yoctoproject.org/releases/yocto/yocto-${RELEASE}/buildtools/${buildtools_installer}"

echo "Verifying checksum..."
echo "${SHA256SUM} ${buildtools_installer}" > checksum.sha256sum
sha256sum --check checksum.sha256sum

echo "Installing Yocto Buildtools..."
bash ${buildtools_installer} -y

echo "Cleaning up..."
rm checksum.sha256sum
rm ${buildtools_installer}
