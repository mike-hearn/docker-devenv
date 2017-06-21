FROM debian:unstable

# Install all base utilities
RUN apt-get update && apt-get install -y \
    autojump \
    autoconf \
    automake \
    build-essential \
    cmake \
    curl \
    dnsutils \
    git \
    htop \
    ipython \
    ipython3 \
    libfontconfig \
    libjpeg-dev \
    libpq-dev \
    locales \
    man \
    mosh \
    neovim \
    postgresql \
    python \
    python-dev \
    python-pip \
    python3-dev \
    python3-pip \
    ruby \
    ruby-dev \
    silversearcher-ag \
    ssh \
    sudo \
    tmux \
    tree \
    vim-nox \
    zlib1g-dev

# Install python libraries
RUN pip install \
    docker-compose \
    flake8 \
    isort \
    neovim \
    pylint \
    virtualenv \
    yapf
RUN pip3 install \
    docker-compose \
    flake8 \
    isort \
    neovim \
    pylint \
    virtualenv \
    yapf

# Install Ruby libraries
RUN gem install compass
RUN gem install tmuxinator

# Install Docker
RUN curl -sSL https://get.docker.com/ | sh

# Install Node.js and associated libraries
RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
RUN apt-get update && apt-get install -y nodejs
RUN curl -o- -L https://yarnpkg.com/install.sh | bash

# Set the locale
RUN localedef -i en_US -f UTF-8 en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Pull in variable arguments to be used in remaining Dockerfile commands
ARG username
ARG publickey

# Create the default user without a password
RUN useradd -ms /bin/bash -u 360 $username
RUN passwd -d $username
RUN chage -d 0 $username
RUN gpasswd -a $username docker
RUN echo "$username    ALL=(ALL:ALL) ALL" >> /etc/sudoers

# Add a public key auth to default user & remove SSH password auth
RUN mkdir -p /home/$username/.ssh && echo $publickey >> /home/$username/.ssh/authorized_keys
RUN chown -R $username:$username /home/$username
RUN chmod 700 /home/$username/.ssh
RUN chmod 400 /home/$username/.ssh/authorized_keys
RUN sed -ri 's/\#?PasswordAuthentication\s*yes/PasswordAuthentication\tno/g' /etc/ssh/sshd_config
RUN echo PermitRootLogin no >> /etc/ssh/sshd_config

CMD service ssh restart && \
    tail -f /dev/null
