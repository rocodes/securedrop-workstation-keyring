#!/usr/bin/bash
# Helper script for fully reproducible RPMs
set -e
set -u
set -o pipefail

source "$(dirname "$0")/common.sh"

# There is no build step, so we can omit the tarball
# step that is used in the sdw config rpm

rpmbuild \
    --quiet \
    --define "_topdir $PWD/rpm-build" \
    -bb --clean "rpm-build/SPECS/${PROJECT}.spec"

printf '\nBuild complete! RPMs and their checksums are:\n\n'
find rpm-build/ -type f -iname "${PROJECT}-$(cat "${TOPLEVEL}/VERSION")*.rpm" -print0 | sort -zV | xargs -0 sha256sum
