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

# Enabling Jenkins slave agents

By default, Jenkins will pick a random port to allow slave nodes launched
by JNLP. Since Docker networking is basically a firewall, a random port
won't work for us. Instead the fixed port **38252** was chosen (arbitrarily)
to be exposed by the container.

Launch your Jenkins container using

    ID=$(docker run -d -p 8080:8080 -p 38252:38252 itzg/jenkins)

and configure the port in the Global Security settings:

![](http://i.imgur.com/PhQiEHy.png)

# Image Parameters

## Volumes

* `/data` - a majority of the Jenkins content is maintained here, such as workspaces
* `/root` - some tools, such as Maven, utilize the home directory for default repository storage
* `/opt/jenkins` - the installed distribution is expanded here

## Ports

* `8080` - for the web UI
* `38252` - for slave incoming JMX access

## Environment Variables

* `JENKINS_OPTS` - passed to the initial Java invocation of Jenkins
