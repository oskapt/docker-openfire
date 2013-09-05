#!/bin/bash

chown -R openfire:openfire /etc/openfire /var/lib/openfire
sudo -u openfire -H /usr/lib/jvm/default-java/bin/java -server -DopenfireHome=/usr/share/openfire -Dopenfire.lib.dir=/usr/share/openfire/lib -classpath /usr/share/openfire/lib/startup.jar -jar /usr/share/openfire/lib/startup.jar

