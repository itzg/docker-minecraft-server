Provides a ready-to-use instance of [GitBlit](http://gitblit.com/).

## Basic usage

Start the GitBlit container using

    docker run -d -p 80:80 -p 443:443 --name gitblit itzg/gitblit

Access its web interface at the mapped HTTP (80) or HTTPS (443) port of the
Docker host. Login with the default credentials __admin__ / __admin__ .


## Data volume

In order to allow for future upgrades, run the container with a volume mount of `/data`, such as:

    -v /tmp/gitblit-data:/data

## Initial repository creation

As a convenience for cluster configuration management with git
(such as with [Spring Cloud Config](https://cloud.spring.io/spring-cloud-config/)),
you may specify the name of an initial repository to be owned by the 'admin' user.
This can be enabled by passing the name of that repository via the environment
variable `GITBLIT_INITIAL_REPO`, such as

    -e GITBLIT_INITIAL_REPO=default

## Create repositories with content

In addition to the approach above, you can push repostories with existing
content by attaching them to sub-directories of `/repos`, such as

    docker run -v $HOME/git/example:/repos/example ...

## Custom configuration

You can add or override any of the `*.properties` files for configuring GitBlit,
typically `gitblit.properties`, by placing those files in a volume attached at
`/config`, such as

    -v $(pwd)/extra-config:/config

The property files in that configuration directory will be renamed with the
suffix `.applied` to avoid overwriting manually modified configuration on
the next container startup.
