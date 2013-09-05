FROM monachus/base

MAINTAINER Adrian Goins "monachus@arces.net"

RUN apt-get -y update
RUN apt-get install -y openjdk-7-jre-headless default-jre git-annex

ADD openfire_3.8.2_all.deb /tmp/
RUN dpkg -i /tmp/openfire_3.8.2_all.deb

ADD docker.conf /etc/supervisor/conf.d/
ADD start /start
RUN chmod 755 /start

EXPOSE 9090:9090
EXPOSE 9091:9091
EXPOSE 5222:5222
EXPOSE 5223:5223

ENTRYPOINT ["/start"]
