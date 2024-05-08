#!/usr/bin/bash
# Helper script for fully reproducible RPMs
set -e
set -u
set -o pipefail

source "$(dirname "$0")/common.sh"

# Prepare tarball for rpmbuild
mkdir -p src/
git clean -fdX rpm-build/ src/
tar -zcvf src/"${PROJECT}"-"$(cat VERSION)".tar.gz files/

# Place tarball where rpmbuild will find it
cp src/*.tar.gz rpm-build/SOURCES/

rpmbuild \
    --quiet \
    --define "_topdir $PWD/rpm-build" \
    -bb --clean "rpm-build/SPECS/${PROJECT}.spec"

printf '\nBuild complete! RPMs and their checksums are:\n\n'
find rpm-build/ -type f -iname "${PROJECT}-$(cat "${TOPLEVEL}/VERSION")*.rpm" -print0 | sort -zV | xargs -0 sha256sum
