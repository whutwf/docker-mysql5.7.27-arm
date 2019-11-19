FROM arm64v8/centos:7
MAINTAINER Felix <whutwf@outlook.com>

RUN groupadd -r mysql && useradd -r -g mysql -s /sbin/nologin -M mysql && \
    yum -y install libaio* wget && \
    wget https://obs.cn-north-4.myhuaweicloud.com/obs-mirror-ftp4/database/mysql-5.7.27-aarch64.tar.gz --no-check-certificate && \
    yum clean all

ENV MYSQL_VERSION=5.7.27-aarch64 \
    MYSQL_WORKDIR=/usr/local \
    TZ=Asia/Shanghai 

RUN set -ex && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    tar -xvf mysql-${MYSQL_VERSION}.tar.gz -C ${MYSQL_WORKDIR}/ && \
    rm -rf mysql-${MYSQL_VERSION}.tar.gz && \
    mv ${MYSQL_WORKDIR}/mysql-${MYSQL_VERSION} ${MYSQL_WORKDIR}/mysql && \
    mkdir -p ${MYSQL_WORKDIR}/mysql/logs && \
    chown -R mysql:mysql ${MYSQL_WORKDIR}/mysql && \
    chown -R mysql:mysql /dev/shm && \
    ln -sf  ${MYSQL_WORKDIR}/mysql/my.cnf /etc/my.cnf && \
    cp -rf ${MYSQL_WORKDIR}/mysql/extra/lib* /usr/lib64/ && \
    mv /usr/lib64/libstdc++.so.6 /usr/lib64/libstdc++.so.6.old && \
    ln -s /usr/lib64/libstdc++.so.6.0.24 /usr/lib64/libstdc++.so.6 && \
    cp -rf ${MYSQL_WORKDIR}/mysql/support-files/mysql.server /etc/init.d/mysqld && \
    chmod +x /etc/init.d/mysqld && \
    systemctl enable mysqld

WORKDIR ${MYSQL_WORKDIR}/mysql

EXPOSE 3306
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["./bin/mysqld"]
