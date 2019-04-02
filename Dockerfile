FROM ubuntu:18.04

LABEL maintainer="anton@sirius.if.ua" \
      version="1.0" \
      description="1C modification of PostgreSQL ver 10.5-24.1C"

ENV POSTGRES_USER=postgres     \
    POSTGRES_PASSWORD=password \
    PGDATA="/var/1C/postgresql-10/data"
ENV LANG=uk_UA.UTF-8 LANGUAGE=ru
ENV LC_ALL=${LANG} \
    PATH="/usr/lib/postgresql/10/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

RUN DEBIAN_FRONTEND=noninteractive \
    sed -i 's/^deb http:\/\/archive/deb http:\/\/ua.archive/g' /etc/apt/sources.list &&\
    apt-get update &&\
    apt-get -y install locales locales-all gosu tzdata >/dev/null 2>&1 &&\
    /usr/sbin/locale-gen ${LANG} ru_RU.UTF-8 ru_UA.UTF-8 uk_UA.UTF-8 &&\
    echo "LANG=\"${LANG}\"\nLANGUAGE=\"${LANGUAGE}\"" > /etc/default/locale &&\
    ln -fs /usr/share/zoneinfo/Europe/Kiev /etc/localtime &&\
    dpkg-reconfigure --frontend noninteractive tzdata >/dev/null 2>&1 &&\
    apt-get -y upgrade &&\
    apt-get -y install htop sudo iputils-ping vim-tiny &&\
    ln -s /usr/bin/vim.tiny /usr/bin/vim &&\
    apt-get -y install libgssapi-krb5-2 libssl1.0.0 libldap-2.4-2 \
                       postgresql-common postgresql-client-common \
                       libedit2 libxslt1.1 ssl-cert &&\
    apt-get -y autoremove &&\
    rm -rf /var/lib/apt/lists/*

# RUN apt-get -y install ssh supervisor &&\
#     sed -i 's/.*PermitRootLogin.*/PermitRootLogin yes/; s/^.*Port .*$/Port 2222/' /etc/ssh/sshd_config &&\
#     mkdir /run/sshd
# EXPOSE 2222:2222

COPY assets /root/

WORKDIR /root/postgresql
RUN dpkg -i libicu*_amd64.deb &&\
    dpkg -i libpq5_10*1C_amd64.deb &&\
    dpkg -i postgresql-client-10*1C_amd64.deb &&\
    dpkg -i postgresql-10*1C_amd64.deb &&\
    rm -rf /var/lib/postgresql/10/main &&\
    echo "export PATH=\"${PATH}\"" >> /etc/environment

EXPOSE 5432:5432

# VOLUME ${PGDATA}

WORKDIR /
ENTRYPOINT ["/root/docker-entrypoint.sh"]
