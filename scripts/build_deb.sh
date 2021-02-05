#!/usr/bin/env bash

DEFAULT_BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BASE_DIR=${PACKAGE_BASE_DIR:-${DEFAULT_BASE_DIR}}

PACKAGE_ARCH=$(dpkg --print-architecture)
PACKAGE_TMPDIR=${PACKAGE_TMPDIR:-debpkg}
PACKAGE_RELEASE=${PACKAGE_RELEASE:-1}
PACKAGE_FULLNAME="${PACKAGE_NAME}_${PACKAGE_VERSION}-${PACKAGE_RELEASE}_${PACKAGE_ARCH}"

rm -fr ${BASE_DIR}/${PACKAGE_TMPDIR}

# Create debian files.
mkdir -p ${BASE_DIR}/${PACKAGE_TMPDIR}/DEBIAN
echo "Package: ${PACKAGE_NAME}
Version: ${PACKAGE_VERSION}-${PACKAGE_RELEASE}
Section: utils
Priority: optional
Architecture: ${PACKAGE_ARCH}
Homepage: https://github.com/eosswedenorg/eosio-unpack-abi
Maintainer: Henrik Hautakoski <henrik@eossweden.org>
Description: ${PACKAGE_DESCRIPTION}" &> ${BASE_DIR}/${PACKAGE_TMPDIR}/DEBIAN/control

mkdir -p ${BASE_DIR}/${PACKAGE_TMPDIR}/${PACKAGE_BINDIR}
#mkdir -p ${BASE_DIR}/${PACKAGE_TMPDIR}/${PACKAGE_MANDIR}
mkdir -p ${BASE_DIR}/${PACKAGE_TMPDIR}/${PACKAGE_SHAREDIR}

cp ${BASE_DIR}/eosio-unpack-abi ${BASE_DIR}/${PACKAGE_TMPDIR}/${PACKAGE_BINDIR}
cp LICENSE ${BASE_DIR}/${PACKAGE_TMPDIR}/${PACKAGE_SHAREDIR}

dpkg-deb --root-owner-group --build ${BASE_DIR}/${PACKAGE_TMPDIR} ${BASE_DIR}/${PACKAGE_FULLNAME}.deb
