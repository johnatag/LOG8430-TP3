# Sample container image with Ubuntu Focal + Systemd + Sshd + Docker.
#
# Usage:
#
# $ docker run --runtime=sysbox-runc -it --rm -P --name=syscont nestybox/ubuntu-focal-systemd-docker
#
# This will run systemd and prompt for a user login; the default
# user/password in this image is "admin/admin". Once you log in you
# can run Docker inside as usual. You can also ssh into the image:
#
# $ ssh admin@<host-ip> -p <host-port>
#
# where <host-port> is chosen by Docker and mapped into the system container's sshd port.
#

FROM ghcr.io/nestybox/ubuntu-jammy-systemd:latest

# Install Docker
RUN apt-get update && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh \
    # Add user "admin" to the Docker group
    && usermod -a -G docker admin
ADD https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker /etc/bash_completion.d/docker.sh

# Install Sshd
RUN apt-get update && apt-get install --no-install-recommends -y openssh-server \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /home/admin/.ssh \
    && chown admin:admin /home/admin/.ssh

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER admin
# Intall dependencies
RUN sudo apt-get update && sudo apt-get install --no-install-recommends -y python2 \
	python3-virtualenv \
	default-jre \
	maven \
	python2-pip-whl \
	python2-setuptools-whl

RUN git clone http://github.com/brianfrankcooper/YCSB.git
RUN sudo update-alternatives --install /usr/bin/python python /usr/bin/python2 1
WORKDIR /home/admin/YCSB/
RUN mvn -pl site.ycsb:redis-binding -am clean package

COPY script.sh /home/admin/
RUN sudo chmod +x /home/admin/script.sh

USER root
EXPOSE 22

# Set systemd as entrypoint.
ENTRYPOINT [ "/sbin/init", "--log-level=err" ]
CMD ["sh", "/home/admin/script.sh"]
