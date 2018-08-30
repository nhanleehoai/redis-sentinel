FROM centos:7
MAINTAINER Nhan Le <nhanleehoai@yahoo.com>

ARG URL=http://download.redis.io/releases/redis-4.0.11.tar.gz

WORKDIR /tmp

RUN yum update -y && \
yum install -y wget make gcc tcl which && \
wget -O redis.tar.gz "${URL}" && \
mkdir /usr/src/redis && \
tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1 && \
cd /usr/src/redis/deps && make hiredis lua jemalloc linenoise && \
cd /usr/src/redis && make && make install &&\
rm -f redis.tar.gz && \
rm -rf /var/cache/yum

COPY redis-slave-init.sh /tmp/redis-slave-init.sh
COPY redis.conf /tmp/redis.conf
COPY sentinel.conf /tmp/sentinel.conf

RUN chmod +x /tmp/redis-slave-init.sh && \
	chmod +x /etc/rc.d/rc.local && \
	echo 'sysctl -w net.core.somaxconn=65535' >> /etc/rc.local &&\
	echo 'vm.overcommit_memory = 1' >> /etc/sysctl.conf

CMD ["redis-server","--protected-mode no"]
# we need to turn off protected mode so that redis can be connected from other Docker container such as NodeJs.