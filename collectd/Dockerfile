FROM centos:latest
MAINTAINER Ravi Elluri <nelluri@redhat.com>

# Install ansible, collectd
RUN yum install -y wget git collectd
RUN wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && rpm -i epel-release-latest-7.noarch.rpm  && yum install -y ansible

# setup collectd
RUN mkdir -p /root/collectd
COPY collectd.conf /etc/collectd.conf
COPY script.sh /root/collectd/script.sh
RUN chmod +x /root/collectd/script.sh
ENTRYPOINT  ["/root/collectd/script.sh"]
