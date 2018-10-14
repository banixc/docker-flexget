#!/usr/bin/with-contenv bash

pip install -U pip
# Make sure to install setuptools version >=36 to avoid a race condition, see:
# https://github.com/pypa/setuptools/issues/951
pip install -U setuptools>=36
pip install -U urllib3[socks]
pip install -U chardet
pip install -U irc_bot
pip install -U rarfile


# Install libtorrent-rasterbar, a dependency for both
# flexget plugin `convert_magnet`. as well as deluge.
apk add --update --no-cache --virtual=build-dependencies \
    apk-tools

# Dependency for libtorrent-rasterbar.
apk add --no-cache \
    boost-python@edge \
    boost-system@edge \
    libressl-dev@edge

# libtorrent-rasterbar contains the python bindings libtorrent.
apk add --no-cache \
    libtorrent-rasterbar@testing

# Install flexget last (it might force specific versions of other packages).
pip install -U flexget

pip install -U transmissionrpc

apk add --update --no-cache --virtual=build-dependencies \
    apk-tools

apk add --no-cache \
    py-attrs@edge

apk add --no-cache \
    deluge@testing

# Deluge is missing dependencies.
# https://bugs.alpinelinux.org/issues/7154

apk add --no-cache --virtual=build-dependencies \
    g++ \
    gcc \
    libffi-dev \
    python2-dev

pip2 install -U \
    constantly \
    incremental \
    service_identity


if [ ! -f /config/.password-lock ]; then
    if [ ! -z "$WEB_PASSWD" ]; then
        s6-setuidgid abc touch /config/.password-lock
        s6-setuidgid abc /usr/bin/flexget -c /config/config.yml --loglevel "${FLEXGET_LOG_LEVEL:-debug}" web passwd "$WEB_PASSWD"
    fi
fi
