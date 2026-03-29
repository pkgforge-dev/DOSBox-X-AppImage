#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/dosbox-x.svg
export DESKTOP=/usr/share/applications/com.dosbox_x.DOSBox-X.desktop
export DEPLOY_OPENGL=1
export DEPLOY_PULSE=1
export DEPLOY_PYTHON=1

# Deploy dependencies
quick-sharun /usr/bin/dosbox-x /usr/lib/libfluidsynth.so* /usr/lib/libXtst.so*
echo 'ANYLINUX_DO_NOT_LOAD_LIBS=libpipewire-0.3.so*:${ANYLINUX_DO_NOT_LOAD_LIBS}' >> ./AppDir/.env

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the app normally quits before that time
# then skip this or check if some flag can be passed that makes it stay open
quick-sharun --simple-test ./dist/*.AppImage
