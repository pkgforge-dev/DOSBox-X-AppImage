#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    ffmpeg     \
    fluidsynth \
    glu        \
    libslirp   \
    sdl2_net

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

echo "Making stable build of DOSBox-X..."
echo "---------------------------------------------------------------"
REPO="https://github.com/joncampbell123/dosbox-x"
VERSION="$(git ls-remote --tags "$REPO" | grep -oE 'refs/tags/dosbox-x-v[0-9]+\.[0-9]+\.[0-9]+' | sort -uV | tail -n1 | sed 's/.*dosbox-x-v//')"
git clone --branch "dosbox-x-v$VERSION" --single-branch --recursive --depth 1 "$REPO" ./dosbox-x
echo "$VERSION" > ~/version

cd ./dosbox-x
patch -Np1 -i "../ffmpeg9.patch"
./autogen.sh
./configure --enable-debug --enable-avcodec --prefix=/usr --enable-sdl2
make -j$(nproc)
make install
