# arkime-docker
Docker implementation for Arkime

This Arkime Docker container is designed to start the Capture and Viewer services, but requires pre-built configuration
to connect to an existing Elastic or OpenSearch server.

## Building the Container

To build the container, clone this repository, change into the cloned directory and then run the following:

```docker build -t arkime-docker .```

The build process downloads Ubuntu 22.04 as the base and then downloads Arkime 4.4.0 and install all required dependencies. 
If you need a different version or want to have a different OS Base, change those in the ```Dockerfile```.

## Running the Container

Once build is complete, you need to provide the path for the ```config.ini``` and other prerequisite configs. This can be passed 
through to the Container using the ```--volume``` flag and pointing it to the ```/data/config``` path in the container which is a 
Symbolic Link into the Arkime Working Directory /etc. I recommend pulling the ```/opt/arkime/etc/``` directory from your running Arkime Host
and copying that to the _local config path_ on the host and modifying the ```config.ini``` for the specific host.

It also requires you to increase the default memlock ulimit so it uses the ```--ulimit``` variable to max it out. 

It also requires direct access to the host's network which is why it uses ```--net=host```.

Below is the command to run the Docker Container:

```
docker run --net=host \
   -v <local config path>:/data/config \
   -v <local logs path>:/data/logs \
   -v <local pcap path>:/data/pcap \
   --rm -d \
   --ulimit memlock=4000000000:4000000000 \
   --name arkime arkime-docker
```

**NOTE:** the _local pcap path_ needs to be writeable to all since it uses user nobody to write packet captures locally to the host.

You can verify that it is up and running by running ```docker ps``` and seeing the system up and running. Also, the _local logs path_ will have both 
the ```capture.log``` and ```viewer.log``` files which you can see what is happening.

