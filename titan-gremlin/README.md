Runs the Gremlin console from the Titan Graph Database's "all" distribution.

# Basic Usage

To start the Gremlin console with the default configuration files available:

    docker run -it itzg/titan-gremlin

In order to adjust or further define property files to use within Gremlin,
attach a host directory to the container's `/conf` such as

    docker run -it -v $(pwd)/conf:/conf itzg/titan-gremlin

After running once your host directory will be populated with the distribution-default
configuration files. Modify those or add to them and they will be available during
the next time you (re)start your container.

# Connecting to Cassandra and Elasticsearch Containers

First start containers for Cassandra and Elasticsearch, where the `--name` you choose
can be arbitrary or left off to use a generated name.

    docker run -d --name gremlin-cass itzg/cassandra 
    docker run -d --name gremlin-es itzg/elasticsearch

Now start Gremlin with networking links to those containers with the aliases

* `--link <container>:cass`
* `--link <container>:es`

such as

    docker run -it --rm --link gremlin-cass:cass --link gremlin-es:es itzg/titan-gremlin

and with that you can follow the
[Graph of the Gods example](http://s3.thinkaurelius.com/docs/titan/current/getting-started.html), such as

    gremlin> GraphOfTheGodsFactory.load(g)
    gremlin> saturn = g.V.has('name','saturn').next()
    ==>v[256]
    gremlin> saturn.map()
    ==>name=saturn
    ==>age=10000
    gremlin> saturn.in('father').in('father').name
    ==>hercules
