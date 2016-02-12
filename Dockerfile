# This is a Dockerfile for creating a Manet container from a base Ubuntu 14:04 image.
# Forked from: https://github.com/pdelsante/manet-dockerfile
# Manet's code can be found here: https://github.com/vbauer/manet
#
# To use this container, start it as usual:
#
#    $ sudo docker run pdelsante/manet
#
# Then find out its IP address by running:
#
#    $ sudo docker ps
#    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
#    d1d7165512e2        pdelsante/manet     "/usr/bin/manet"    48 seconds ago      Up 47 seconds       8891/tcp            romantic_cray
#
#    $ sudo docker inspect d1d7165512e2 | grep IPAddress
#         "IPAddress": "172.17.0.1",
#
# Now you can connect to:
#    http://172.17.0.1:8891
#
FROM ubuntu:trusty
MAINTAINER kris@maphubs.com
ENV DEBIAN_FRONTEND noninteractive
EXPOSE 8891

RUN apt-get update && \
    apt-get -y install curl && \
    curl -sL https://deb.nodesource.com/setup_4.x | sudo bash - && \
    apt-get -y install nodejs build-essential xvfb libfontconfig1 firefox && \
    npm install -g slimerjs@0.9.6-2 && \
    npm install -g phantomjs@1.9.19 && \
    npm install -g manet@0.4.9

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV DISPLAY=:99
ADD xvfb_init /etc/init.d/xvfb
ADD xvfb_daemon_run /usr/bin/xvfb-daemon-run
RUN chmod a+x /etc/init.d/xvfb && chmod a+x /usr/bin/xvfb-daemon-run

ADD entrypoint.sh /root/entrypoint.sh
RUN chmod a+x /root/entrypoint.sh

ENTRYPOINT ["/root/entrypoint.sh"]
