#Dockerfile for pbench-agent
FROM centos/tools
MAINTAINER Ravi Elluri <nelluri@redhat.com>

# Setup pbench
RUN curl -s https://copr.fedorainfracloud.org/coprs/ndokos/pbench-interim/repo/epel-7/ndokos-pbench-interim-epel-7.repo > /etc/yum.repos.d/copr-pbench.repo && \
    yum --enablerepo=ndokos-pbench-interim install -y configtools openssh-clients pbench-agent iproute sysvinit-tools openssh-server git && \
    source /etc/profile.d/pbench-agent.sh && \
    curl -L https://github.com/openshift/origin/releases/download/v1.2.1/openshift-origin-client-tools-v1.2.1-5e723f6-linux-64bit.tar.gz | tar -zx && \
    mv openshift*/oc /usr/local/bin && \
    rm -rf openshift-origin-client-tools-*

# Install ansible, other dependencies
RUN mkdir -p /root/.ssh 
RUN rpm -iUvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && yum install -y ansible python-pip which
RUN pip install requests

# Setup sshd, initscripts
RUN yum install -y openssh-server openssh-clients initscripts && yum clean all
RUN sed -i "s/#Port 22/Port 2022/" /etc/ssh/sshd_config
RUN systemctl enable sshd
EXPOSE 2022

# Mount /proc
COPY mount.sh /root/mount.sh
RUN chmod +x /root/mount.sh
COPY pbench.service /etc/systemd/system/pbench.service
RUN systemctl enable pbench.service

ENTRYPOINT ["/usr/sbin/init"]
