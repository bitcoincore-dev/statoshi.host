#!/bin/sh
# Copyright (c) 2013-2019 The Bitcoin Core developers
# Distributed under the MIT software license, see the accompanying
# file COPYING or http://www.opensource.org/licenses/mit-license.php.

export LC_ALL=C
set -e
srcdir="$(dirname "$0")"
cd "$srcdir"
if [ -z "${LIBTOOLIZE}" ] && GLIBTOOLIZE="$(command -v glibtoolize)"; then
  LIBTOOLIZE="${GLIBTOOLIZE}"
  export LIBTOOLIZE
fi
command -v autoreconf >/dev/null || \
  (echo "configuration failed, please install autoconf first" && exit 1)
autoreconf --install --force --warnings=all

#mkdir -p /usr/local/include/
#cd "$srcdir"
#install -v $srcdir/src/statsd_client.h /usr/local/include/statsd_client.h
#install -v $srcdir/src/statsd_client.cpp /usr/local/include/statsd_client.cpp
