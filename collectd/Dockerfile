FROM centos:latest
MAINTAINER Ravi Elluri <nelluri@redhat.com>

# Install ansible, collectd
RUN yum install -y wget git collectd
RUN wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && rpm -i epel-release-latest-7.noarch.rpm  && yum install -y ansible

# setup systemd
ENV container docker
RUN yum -y swap -- remove fakesystemd -- install systemd systemd-libs
RUN yum -y update; yum clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

# Setup sshd
RUN yum install -y openssh-server openssh-clients && yum clean all
RUN sed -i "s/#Port 22/Port 2222/" /etc/ssh/sshd_config
RUN systemctl enable sshd
EXPOSE 2222

# setup collectd
RUN mkdir -p /root/collectd
COPY collectd.conf /etc/collectd.conf
COPY script.sh /root/collectd/script.sh
RUN chmod +x /root/collectd/script.sh 
COPY collectd-wrapper.service /etc/systemd/system/collectd-wrapper.service
RUN systemctl enable collectd-wrapper.service 
ENTRYPOINT  ["/usr/sbin/init"]
