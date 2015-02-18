A self-upgrading [Jenkins CI](http://jenkins-ci.org/) server

# Basic Usage

To start Jenkins with the latest version:

    ID=$(docker run -d -p 8080:8080 itzg/jenkins)

At a later time, you can upgrade by restarting the container:

    docker stop $ID
    docker start $ID

# Attaching host directory to Jenkins home directory

The Jenkins home directory is attachable at `/data`, so attaching to a host volume
would be:

    ID=$(docker run -d -p 8080:8080 -v /SOME_HOST_DIR:/data itzg/jenkins

# Entering the container to perform manual config

As with any Docker container, you can run a shell within the running container:

    docker exec -it $ID bash

A more realistic example is installing git, openjdk-7-jdk, etc:

    docker exec $ID apt-get update
    docker exec $ID apt-get install -y git openjdk-7-jdk

and then Configure the JDK in Jenkins:

![](http://i.imgur.com/HVetwKc.png)

# Enabling Jenkins slave agents

By default, Jenkins will pick a random port to allow slave nodes launched
by JNLP. Since Docker networking is basically a firewall, a random port
won't work for us. Instead the fixed port **38252** was chosen (arbitrarily)
to be exposed by the container.

Launch your Jenkins container using

    ID=$(docker run -d -p 8080:8080 -p 38252:38252 itzg/jenkins)

and configure the port in the Global Security settings:

![](http://i.imgur.com/PhQiEHy.png)
