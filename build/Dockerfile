FROM ubuntu

MAINTAINER Adrian Goins "monachus@arces.net"

RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ precise main restricted universe" > /etc/apt/sources.list && apt-get -qq update
RUN apt-get install -qq python-software-properties supervisor openjdk-7-jre-headless default-jre

ADD openfire_3.8.2_all.deb /tmp/
RUN dpkg -i /tmp/openfire_3.8.2_all.deb

ADD docker.conf /etc/supervisor/conf.d/
ADD start /start
RUN chmod 755 /start

EXPOSE 9090 9091 5222 5223 5269 9999

ENTRYPOINT ["/bin/bash", "/start"]
