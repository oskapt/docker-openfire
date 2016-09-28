FROM anapsix/alpine-java

MAINTAINER Adrian Goins "monachus@arces.net"

RUN apk --no-cache add ca-certificates wget

# Install [dumb-init](https://github.com/Yelp/dumb-init)
ENV DI_VERSION 1.1.3
RUN cd /tmp && \
    wget -q -O /bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${DI_VERSION}/dumb-init_${DI_VERSION}_amd64 && \
    chmod +x /bin/dumb-init

# Install [Openfire](http://www.igniterealtime.org/projects/openfire/index.jsp)
ENV OF_VERSION 4.0.3
RUN cd /usr/share && \
    wget -q -O - http://www.igniterealtime.org/downloadServlet?filename=openfire/openfire_$( echo ${OF_VERSION} | sed -e 's/\./_/g' ).tar.gz | tar xzf -

ADD start /start
RUN chmod 755 /start

EXPOSE 9090 9091 5222 5223 5269

ARG VCS_REF
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/oskapt/docker-openfire"

CMD ["dumb-init", "/start"]
