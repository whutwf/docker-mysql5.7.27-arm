#!/bin/bash

#运行某一行出错时立即退出
set -o errexit 

# 默认初始化密码
MYSQL_ROOT_PWD=${MYSQL_ROOT_PWD:=""}

if [ -z "$(ls -A /usr/local/mysql/data/)" ] ; then
    #初始化数据库
    /usr/local/mysql/bin/mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data 2>&1
    # $? 脚本退出码
    [ "$?" -eq 0 ] && echo "init mysql success" || exit 1
    echo "/usr/local/mysql \
        -bin \
        -data \
        -logs \
        -include \
        -lib \
        -share \
        -my.cnf"

    /etc/init.d/mysqld restart && sleep 3
    portready=$(ss -lntp|grep "3306"|wc -l)
    for p in {3..0}; do
        if [ $port -ne 1 ];then
            /etc/init.d/mysqld restart && sleep 2
        else
            break
        fi
        if [ "$p" = 0 ];then
            echo >&2 'mysqld start fail'
            exit 1
        fi
    done

    [ "$?" -eq 0 ] && echo "mysqld start success" || exit 1

    #根据用户参数修改密码
    MYSQL57_ROOT_TMP_PWD=$(grep "A temporary password" /usr/local/mysql/logs/mysql-error.log |awk '{print $NF}')
    if ["${MYSQL_ROOT_PWD}" == ""]; then
        MYSQL_ROOT_PWD="Huawei@123"
    fi

    MYSQL_PWD=${MYSQL57_ROOT_TMP_PWD} /usr/local/mysql/bin/mysql -u root --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PWD}' ;"
    [ "$?" -eq 0 ] && echo "password reset: ${MYSQL_ROOT_PWD}" || exit 1
fi
/etc/init.d/mysqld stop && sleep 1 
[ "$?" -eq 0 ] && echo "mysqld stop success" || exit 1
exec "$@"
