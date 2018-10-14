FROM lsiobase/alpine.python:3.7

# Set python to use utf-8 rather than ascii.
ENV PYTHONIOENCODING="UTF-8"
ENV TORRENT_PLUGIN="transmission|deluge"

# Copy local files.
COPY etc/ /etc

# Add edge/testing repositories.
RUN printf "\
@edge http://nl.alpinelinux.org/alpine/edge/main\n\
@testing http://nl.alpinelinux.org/alpine/edge/testing\n\
@community http://nl.alpinelinux.org/alpine/edge/community\n\
" >> /etc/apk/repositories && chmod -v +x /etc/services.d/*/run && sh /etc/init.sh

# Ports and volumes.
EXPOSE 5050/tcp
VOLUME /config
