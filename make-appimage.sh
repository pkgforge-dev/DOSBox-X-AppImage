#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q dosbox-x-sdl2 | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/dosbox-x.svg
export DESKTOP=/usr/share/applications/com.dosbox_x.DOSBox-X.desktop

# Deploy dependencies
#mv -v /usr/share/dosbox-x/ .AppDir/bin
quick-sharun /usr/bin/dosbox-x

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the app normally quits before that time
# then skip this or check if some flag can be passed that makes it stay open
quick-sharun --test ./dist/*.AppImage
