FROM ubuntu:22.04
MAINTAINER Luke.Williams "Luke.Williams@beyondedgenetworks.com"

RUN apt update && apt upgrade -y && apt install -y wget curl libmagic-dev logrotate iproute2

# Environment Variables
ENV ES_HOST "elasticsearch"
ENV ES_PORT "9200"
ENV ARKIME_INTERFACE "eth0"
ENV ARKIME_ADMIN_PASSWORD "admin"
ENV ARKIME_HOSTNAME "localhost"
ENV ARKIMEDIR "/opt/arkime"
ENV CAPTURE "on"
ENV VIEWER "off"

# Setup Arkime
RUN mkdir -p /data
RUN cd /data
RUN wget https://s3.amazonaws.com/files.molo.ch/builds/ubuntu-22.04/arkime_4.4.0-1_amd64.deb
RUN apt install -y ./arkime_4.4.0-1_amd64.deb
RUN mv /opt/arkime/etc /data/config
RUN ln -s /data/config /opt/arkime/etc
RUN ln -s /data/logs /opt/arkime/logs
RUN ln -s /data/pcap /opt/arkime/raw

# Cleaning
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/* /arkime_4.4.0-1_amd64.deb

# Add the scripts
ADD /scripts /data/
RUN chmod 755 data/*.sh

# The volums:
VOLUME ["/data/pcap", "/data/config", "/data/logs"]
WORKDIR /opt/arkime
EXPOSE 8005

ENTRYPOINT ["/data/startarkime.sh"]
