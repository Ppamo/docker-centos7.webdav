FROM centos:centos7
MAINTAINER "Ppamo" <pablo@ppamo.cl>

# update system and install httpd
RUN yum -y --setopt=tsflags=nodocs update && \
	yum -y --setopt=tsflags=nodocs install httpd && \
	yum clean all

# setup shared folder
RUN mkdir /var/www/html/webdav && \
	chown -R apache:apache /var/www && \
	chmod -R 755 /var/www/html/webdav

# setup user passwd
COPY htpasswd /etc/httpd/.htpasswd
RUN chown root:apache /etc/httpd/.htpasswd && \
	chmod 640 /etc/httpd/.htpasswd

# copy apache config file
RUN rm -f /etc/httpd/conf.d/*
COPY webdav.conf /etc/httpd/conf.d/webdav.conf

EXPOSE 80
CMD ["httpd", "-DFOREGROUND"]
