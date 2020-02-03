FROM ubuntu:18.04

LABEL maintainer="soulteary@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y && \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y lsb-release curl && \
    # deps from: https://raw.githubusercontent.com/phacility/phabricator/stable/scripts/install/install_ubuntu.sh
    apt-get install -y tzdata sudo && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    apt-get install -y git apache2 libapache2-mod-php php php-mysql php-gd php-curl php-apcu php-cli php-json php-mbstring php-zip python python-pip && \
    a2enmod rewrite && \
    pip install Pygments

WORKDIR /opt

RUN git clone https://github.com/phacility/phabricator.git --branch=stable --depth=1 && \
    cd phabricator && \
    git checkout cc11dff7d317b5a1e82e24ab571fef9abb633a49

RUN git clone https://github.com/phacility/arcanist.git --branch=stable --depth=1 && \
    cd arcanist && \
    git checkout 729100955129851a52588cdfd9b425197cf05815

RUN git clone https://github.com/phacility/libphutil.git --branch=stable --depth=1 && \
    cd libphutil && \
    git checkout 034cf7cc39940b935e83923dbb1bacbcfe645a85

RUN git clone https://github.com/arielyang/phabricator_zh_Hans.git --branch=master --depth=1 && \
    cd phabricator_zh_Hans && \
    git checkout 17ce992806cb3d08ec485776731e1e02cd4f9877 && \
    cp dist/\(stable\)\ Promote\ 2020\ Week\ 5/PhabricatorSimplifiedChineseTranslation.php ../phabricator/src/extensions/

COPY phabricator/docker-assets ./assets

RUN sed -i -e "s/post_max_size = 8M/post_max_size = 32M/g" /etc/php/7.2/apache2/php.ini && \
    sed -i -e "s/;opcache.validate_timestamps=1/opcache.validate_timestamps = 0/g" /etc/php/7.2/apache2/php.ini

RUN useradd daemon-user && \
    mkdir -p /data/repo && \
    mkdir -p /data/stor && \
    chown -R daemon-user:daemon-user /data && \
    ln -s /usr/lib/git-core/git-http-backend /usr/bin/ && \
    echo "Cmnd_Alias GIT_CMDS = /usr/bin/git*" >> /etc/sudoers.d/www-user-git && \
    echo "www-data ALL=(daemon-user) SETENV: NOPASSWD: GIT_CMDS" >> /etc/sudoers.d/www-user-git && \
    chmod 0440 /etc/sudoers.d/www-user-git

ENTRYPOINT ["bash", "-c", "/opt/assets/entrypoint.sh"]

EXPOSE 80