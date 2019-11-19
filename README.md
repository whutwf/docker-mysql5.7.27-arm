# 创建Arm64 Docker镜像
```
[root@ecs-arm docker-arm-mysql5.7.27]# docker build -t mysql:v1 .

// 启动容器：加参数-e MYSQL_ROOT_PWD="Huawei"，修改root密码为你自己的密码; 未加此参数，密码默认为 "Huawei@123"
[root@ecs-arm docker-arm-mysql5.7.27]# docker run -idt -p 3306:3306 -e MYSQL_ROOT_PWD="Huawei"  --name mymysql mysql:v1

// 查看容器进程是否正常启动
[root@ecs-arm docker-arm-mysql5.7.22]# docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
341c2f5819b6        mysql:v2            "/entrypoint.sh ./..."   5 minutes ago       Up 5 minutes        0.0.0.0:3306->3306/tcp   mymysql

// 查看容器运行日志，查看Mysql密码
[root@ecs-arm docker-arm-mysql5.7.22]# docker logs 341c2f5819b6
password reset: Huawei
Shutting down MySQL.. SUCCESS! 
mysqld stop success

// 进入容器，验证Mysql
[root@ecs-arm docker-arm-mysql5.7.22]# docker exec -it 341c2f5819b6  /bin/sh
sh-4.2# ./bin/mysql -uroot -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 4
Server version: 5.7.22-log Source distribution

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.00 sec)

```
