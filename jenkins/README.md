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
