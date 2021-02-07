FROM homebrew/brew

ARG USERID
ARG USERNAME
ARG GROUPID

RUN apt-get update
RUN apt-get install -y \
	docker.io \
	openssh-server \
	sudo

# Setup ssh server
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
RUN mkdir /run/sshd
EXPOSE 22

RUN adduser ${USERNAME:-testuser} --uid ${USERID} || printf "\nUser $(id -nu $USERID) already exists\n\n"

CMD sudo /usr/sbin/sshd -p 22 -d
