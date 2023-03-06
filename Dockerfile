FROM ubuntu:latest
RUN useradd -ms /bin/bash ubuntu -p pub123
USER ubuntu
WORKDIR /home/ubuntu
RUN apt update && apt install  openssh-server sudo -y
# Create a user “sshuser” and group “sshgroup”
RUN groupadd sshgroup && useradd -ms /bin/bash -g sshgroup ubuntu
# Create sshuser directory in home
RUN mkdir -p /home/ubuntu/.ssh
# Copy the ssh public key in the authorized_keys file. The idkey.pub below is a public key file you get from ssh-keygen. They are under ~/.ssh directory by default.
COPY id_ed25519.pub /home/ubuntu/.ssh/authorized_keys
# change ownership of the key file. 
RUN chown ubuntu:sshgroup /home/ubuntu/.ssh/authorized_keys && chmod 600 /home/ubuntu/.ssh/authorized_keys
# Start SSH service
RUN service ssh start
# Expose docker port 22
EXPOSE 22
CMD ["/usr/sbin/sshd","-D",]