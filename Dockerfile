FROM arm64v8/centos:7
MAINTAINER Felix <whutwf@outlook.com>

RUN groupadd -r mysql && useradd -r -g mysql -s /sbin/nologin -M mysql && \
    yum -y update && \
    yum -y install gcc gcc-c++ libtool cmake ncurses-devel bison libaio-devel libncurses-devel libopenssl-devel zlib-devel autoconf perl per-devel

ENV MYSQL_VERSION=5.7.22-arm64 \
    MYSQL_WORKDIR=/usr/local \
    TZ=Asia/Shanghai 

COPY ./mysql-${MYSQL_VERSION}.tar.gz ${MYSQL_WORKDIR}/mysql-${MYSQL_VERSION}.tar.gz

RUN set -ex && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    tar -xzvf ${MYSQL_WORKDIR}/mysql-${MYSQL_VERSION}.tar.gz -C ${MYSQL_WORKDIR}/ && \
    rm -rf ${MYSQL_WORKDIR}/mysql-${MYSQL_VERSION}.tar.gz && \
    mv ${MYSQL_WORKDIR}/mysql-${MYSQL_VERSION} ${MYSQL_WORKDIR}/mysql && \
    mkdir -p /usr/local/mysql/logs && \
    chown -R mysql:mysql /usr/local/mysql && \
    ln -sf  /usr/local/mysql/my.cnf /etc/my.cnf && \
    cp -rf /usr/local/mysql/extra/lib* /usr/lib64/ && \
    mv /usr/lib64/libstdc++.so.6 /usr/lib64/libstdc++.so.6.old && \
    ln -s /usr/lib64/libstdc++.so.6.0.24 /usr/lib64/libstdc++.so.6 && \
    cp -rf /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld && \
    chmod +x /etc/init.d/mysqld && \
    systemctl enable mysqld

WORKDIR ${MYSQL_WORKDIR}/mysql

EXPOSE 3306
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["./bin/mysqld"]
