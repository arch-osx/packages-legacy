#!/bin/sh

PACKAGEMAKER=/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker
INSTALL_ROOT=~/archroot
PACMAN_CACHE=/opt/arch/var/cache/pacman/pkg
VERSION=`date +%Y%m%d`

DEPS=(
    bzip2
    zlib
    expat
    libiconv
    openssl
    libarchive
    libfetch
    gettext
    pacman-mirrorlist
)

NONDEPS=(
    pacman
    coreutils
    fakeroot
)

install_package() {
    name=$1
    flag=$2
    file=`find ${PACMAN_CACHE} -name "${name}-[0-9]*" | sort -r | head -n 1`
    echo Installing package: ${name} File: ${file}
    pacman -U ${flag} --noprogressbar -r ${INSTALL_ROOT} -b ${INSTALL_ROOT}/opt/arch/var/lib/pacman ${file}
}

if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi


echo Building ArchOSX Installer ${VERSION}

echo Making install root...
mkdir -p ${INSTALL_ROOT}/opt/arch/var/lib/pacman/local

echo Installing dependencies...
for package in ${DEPS[@]}; do
    install_package ${package} --asdeps
done

echo Installing non-dependencies...
for package in ${NONDEPS[@]}; do
    install_package ${package}
done

echo Creating package...
${PACKAGEMAKER} -r ${INSTALL_ROOT} -o ArchOSX-${VERSION}.pkg -i com.googlecode.arch-osx -n ${VERSION} -t ArchOSX -g 10.5 -h system -b

echo Done!
