# This setup is for local development and learning purposes only.
# It is not setup for security or production use.

FROM ubuntu:22.04

# Install SSH server and other useful tools
RUN apt-get update && apt-get install -y \
    openssh-server sudo systemd vim net-tools

# Create SSH directory
RUN mkdir /var/run/sshd

# Create a user (e.g., ansible) and set password
RUN useradd -m ansible && echo "ansible:ansible" | chpasswd && adduser ansible sudo

# Grant the 'ansible' user passwordless sudo privileges
RUN echo "ansible ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible

# Allow password login
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Set environment variable
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Expose SSH port
EXPOSE 22

# Start SSH server
CMD ["/usr/sbin/sshd", "-D"]
