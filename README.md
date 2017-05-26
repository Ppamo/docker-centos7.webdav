# Docker-centos7.webdav
Docker setup for a webdav server, based on centos7 and apache.

### Usage:
./setup.sh

The setup.sh script build the docker image, if it does not exists, then create and set permissions to the webdav folder in host machine, by default set to /opt/webdav, and finally start the container, publising the 80 port.
