Provides a development/build environment for Java, Groovy, and NodeJS.

* Provides 'gvm' for Groovy (and more) installation management
* Provides 'nave' for NodeJS installation management
* Pre-installs the latest NodeJS via nave

## Using the persistent/shared workarea

Since devbox containers are intended to be disposable, the image is configured 
with a "volume" at `/shared`. 

There are a couple of ways you can leverage that volume. Either attach it to
a host-local directory:

    docker run -it -v $(pwd)/workarea:/shared --rm itzg/devbox

or run a "base" container and mounts the `/shared` from that onto any
subsequent containers:

    docker run --name devbox-base itzg/devbox touch /shared/READY
    ...later...
    docker run -it --volumes-from devbox-base --rm itzg/devbox

**NOTE** I am using the `--rm` option so the devbox containers will be truly
"burn after use".
