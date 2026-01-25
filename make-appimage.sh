#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q dosbox-x-sdl2 | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/dosbox-x.svg
export DESKTOP=/usr/share/applications/dosbox-x.desktop

# Deploy dependencies
yes | xvfb-run quick-sharun --deploy /usr/bin/dosbox-x
cp -r /usr/share/dosbox-x/ .AppDir/bin/

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage
