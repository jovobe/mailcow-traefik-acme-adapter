FROM docker:latest
LABEL maintainer "Johan M. von Behren <johan@vonbehren.eu>"

# Installation
RUN apk add --update \
  && apk add --no-cache inotify-tools \
  curl \
  jq \
  openssl \
  util-linux \
  bash \
  tini \
  && curl https://raw.githubusercontent.com/containous/traefik/master/contrib/scripts/dumpcerts.sh -o /dumpcerts.sh \
  && chmod +x /dumpcerts.sh \
  && mkdir -p /dump-target /ssl-share

COPY watcher.sh /watcher.sh

RUN ["chmod", "+x", "/watcher.sh"]

ENTRYPOINT ["/sbin/tini", "-g", "--"]

# CMD /watcher.sh 2> /dev/null
CMD /watcher.sh
