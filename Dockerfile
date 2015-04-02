FROM resin/rpi-raspbian:jessie
MAINTAINER Carlos Moro <dordoka@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y mysql-server pwgen && \
    rm -rf /var/lib/mysql/mysql && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /etc/mysql/conf.d/mysqld_safe_syslog.cnf
    
ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD mysqld_charset.cnf /etc/mysql/conf.d/mysqld_charset.cnf

ADD import_sql.sh /import_sql.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh

EXPOSE 3306

# Exposed ENV
ENV MYSQL_USER admin
ENV MYSQL_PASS **Random**

# Replication ENV
ENV REPLICATION_MASTER **False**
ENV REPLICATION_SLAVE **False**
ENV REPLICATION_USER replica
ENV REPLICATION_PASS replica

# Add VOLUMEs to allow backup of config and databases
VOLUME ["/etc/mysql"]
VOLUME ["/var/lib/mysql"]
VOLUME ["/run/mysqld"]

CMD ["/run.sh"]
