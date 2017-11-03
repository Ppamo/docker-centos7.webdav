#!/bin/bash
IMAGENAME=webdav
IMAGETAG=latest
IMAGEVERSION=v0.1
VOLUMEPATH=/opt/webdav
SERVICEPORT=9000

# check if the assigned port is in use
FOUND=$(netstat -anp --tcp | grep -Eo ":$SERVICEPORT .+LISTEN")
if [ -n "$FOUND" ]; then
	echo "The assigned port ($SERVICEPORT) seems to be in use!"
	exit -1
fi

# check if docker is running
docker info > /dev/null 2>&1
if [ $? -ne 0 ]
then
	echo "Cannot connect to the Docker daemon. Is the docker daemon running on this host?"
	exit -1
fi

# check if the Dockerfile is in the folder
if [ ! -f Dockerfile ]
then
	echo "Dockerfile is not present, please run the script from right folder"
	exit -1
fi

# check if the docker image exists
docker images | grep "$IMAGENAME" | grep "$IMAGETAG" > /dev/null 2>&1
if [ $? -ne 0 ]
then
	# create the docker image
	docker build -t $IMAGENAME:$IMAGEVERSION -t $IMAGENAME:$IMAGETAG ./
	if [ $? -ne 0 ]
	then
		echo "docker build failed!"
		exit -1
	fi
fi

# create volume path
mkdir -p $VOLUMEPATH
chown -R apache.apache $VOLUMEPATH

# selinux permissions to the shared volume
chcon -Rt svirt_sandbox_file_t $VOLUMEPATH

# run a container from $IMAGENAME image
docker run -di -p $SERVICEPORT:80 -v $VOLUMEPATH:/var/www/html/webdav "$IMAGENAME:$IMAGETAG"
echo "LISTEN: http://localhost:9000/"
