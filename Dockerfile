FROM stackbrew/debian:jessie
MAINTAINER Nicole Hubbard <code@nicolehubbard.net>

# Install haproxy
RUN apt-get update
RUN apt-get install -y haproxy

ADD https://raw.githubusercontent.com/jpetazzo/pipework/master/pipework /usr/bin/
RUN chmod a+x /usr/bin/pipework

ENV RUNDIR /run/haproxy

# Install confd
ADD https://github.com/kelseyhightower/confd/releases/download/v0.6.0-alpha1/confd-0.6.0-alpha1-linux-amd64 /usr/local/bin/confd
RUN chmod +x /usr/local/bin/confd

ADD start.sh /start.sh

VOLUME /etc/confd

CMD ["/bin/bash","/start.sh"]