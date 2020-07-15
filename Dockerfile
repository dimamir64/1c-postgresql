FROM ubuntu:20.04

LABEL maintainer="anton@sirius.if.ua" \
      version="1.2" \
      description="1C modification of PostgreSQL ver 12 1C"

ENV POSTGRES_USER=postgres     \
    POSTGRES_PASSWORD=password \
    PGDATA="/var/1C/postgresql-10/data"
ENV LANG=uk_UA.UTF-8 LANGUAGE=ru
ENV LC_ALL=${LANG} \
    PATH="/opt/pgpro/1c-12/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

WORKDIR /root

RUN DEBIAN_FRONTEND=noninteractive \
    sed -i 's/^deb http:\/\/archive/deb http:\/\/ua.archive/g' /etc/apt/sources.list &&\
    apt-get -y -q update &&\
    apt-get -y -q install dialog apt-utils &&\
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections &&\
    apt-get -y -q install htop sudo less mc iputils-ping vim-tiny curl gnupg2 locales locales-all gosu tzdata >/dev/null 2>&1 &&\
    ln -s /usr/bin/vim.tiny /usr/bin/vim &&\
    /usr/sbin/locale-gen ${LANG} ru_RU.UTF-8 ru_UA.UTF-8 uk_UA.UTF-8 &&\
    echo "LANG=\"${LANG}\"\nLANGUAGE=\"${LANGUAGE}\"" > /etc/default/locale &&\
    ln -fs /usr/share/zoneinfo/Europe/Kiev /etc/localtime &&\
    dpkg-reconfigure --frontend noninteractive tzdata >/dev/null 2>&1 &&\
    apt-get -y -q upgrade &&\
    apt-get -y -q autoremove &&\
    curl -o apt-repo-add.sh http://repo.postgrespro.ru/pg1c-12/keys/apt-repo-add.sh &&\
    sh apt-repo-add.sh &&\
    apt-get -y install postgrespro-1c-12-server

# RUN apt-get -y install ssh supervisor &&\
#     sed -i 's/.*PermitRootLogin.*/PermitRootLogin yes/; s/^.*Port .*$/Port 2222/' /etc/ssh/sshd_config &&\
#     sed -i 's/^root.*/root\:$6$8aLWJxueq4k5IsEU$hjkref5Z8LPjiEHuqgmQdsUY0bXAAm7x9jLFTxC\/LnsaBkSlTwk7emXXQhOXGkaUBS\/Ddtb56CMHmVwTwJoFy1\:18457\:0\:99999\:7\:\:\:/' /etc/shadow &&\
#     mkdir /run/sshd &&\
#     rm -rf /var/lib/apt/lists/*
# EXPOSE 2222:2222

COPY assets/supervisor /etc/supervisor
COPY assets/docker-entrypoint.sh /root/docker-entrypoint.sh

RUN rm -rf /var/lib/postgresql/12/main &&\
    mkdir -p /var/log/postgresql &&\
    echo "export PATH=\"${PATH}\"" >> /etc/environment

EXPOSE 5432

WORKDIR /
RUN ln -s /root/docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh", "postgres"]
#CMD ["/usr/bin/supervisord"]
#CMD ["ping", "www.google.com"]
