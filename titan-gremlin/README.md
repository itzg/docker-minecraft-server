Runs the Gremlin console from the Titan Graph Database "all" distribution.

To start the Gremlin console with the default configuration files available:

    docker run -it itzg/titan-gremlin

In order to adjust or further define property files to use within Gremlin,
attach a host directory to the container's `/conf` such as

    docker run -it -v $(pwd)/conf:/conf itzg/titan-gremlin

After running once your host directory will be populated with the distribution-default
configuration files. Modify those or add to them and they will available during
the next use of gremlin.
