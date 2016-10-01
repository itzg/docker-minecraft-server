This Docker image provides an easily configurable Elasticsearch node. Via port mappings, it is easy to create an arbitrarily sized cluster of nodes. As long as the versions match, you can mix-and-match "real" Elasticsearch nodes with container-ized ones.

# Basic Usage

To start an Elasticsearch data node that listens on the standard ports on your host's network interface:

    docker run -d -p 9200:9200 -p 9300:9300 itzg/elasticsearch

You'll then be able to connect to the Elasticsearch HTTP interface to confirm it's alive:

http://DOCKERHOST:9200/

    {
      "status" : 200,
      "name" : "Charon",
      "version" : {
        "number" : "1.3.5",
        "build_hash" : "4a50e7df768fddd572f48830ae9c35e4ded86ac1",
        "build_timestamp" : "2014-11-05T15:21:28Z",
        "build_snapshot" : false,
        "lucene_version" : "4.9"
      },
      "tagline" : "You Know, for Search"
    }

Where `DOCKERHOST` would be the actual hostname of your host running Docker.

# Simple, multi-node cluster

To run a multi-node cluster (3-node in this example) on a single Docker machine use:

    docker run -d --name es0 -p 9200:9200                    es
    docker run -d --name es1 --link es0 -e UNICAST_HOSTS=es0 es
    docker run -d --name es2 --link es0 -e UNICAST_HOSTS=es0 es


and then check the cluster health, such as http://192.168.99.100:9200/_cluster/health?pretty

    {
      "cluster_name" : "elasticsearch",
      "status" : "green",
      "timed_out" : false,
      "number_of_nodes" : 3,
      "number_of_data_nodes" : 3,
      "active_primary_shards" : 0,
      "active_shards" : 0,
      "relocating_shards" : 0,
      "initializing_shards" : 0,
      "unassigned_shards" : 0
    }

# Configuration Summary

## Ports

* `9200` - HTTP REST
* `9300` - Native transport

## Volumes

* `/data` - location of `path.data`
* `/conf` - location of `path.conf`

# Configuration Details

The following configuration options are specified using `docker run` environment variables (`-e`) like

    docker run ... -e NAME=VALUE ... itzg/elasticsearch

Since Docker's `-e` settings are baked into the container definition, this image provides an extra feature to change any of the settings below for an existing container. Either create/edit the file `env` in the `/conf` volume mapping or edit within the running container's context using:

    docker exec -it CONTAINER_ID vi /conf/env

replacing `CONTAINER_ID` with the container's ID or name.

The contents of the `/conf/env` file are standard shell

    NAME=VALUE

entries where `NAME` is one of the variables described below.

Configuration options not explicitly supported below can be specified via the `OPTS` environment variable. For example, by default `OPTS` is set with

    OPTS=-Dnetwork.bind_host=_non_loopback_

_NOTE: That option is a default since `bind_host` defaults to `localhost` as of 2.0, which isn't helpful for
port mapping out from the container_.

## Cluster Name

If joining a pre-existing cluster, then you may need to specify a cluster name different than the default "elasticsearch":

    -e CLUSTER=dockers

## Zen Unicast Hosts

When joining a multi-physical-host cluster, multicast may not be supported on the physical network. In that case, your node can reference specific one or more hosts in the cluster via the [Zen Unicast Hosts](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/modules-discovery-zen.html#unicast) capability as a comma-separated list of `HOST:PORT` pairs:

    -e UNICAST_HOSTS=HOST:PORT[,HOST:PORT]

such as

    -e UNICAST_HOSTS=192.168.0.100:9300

## Plugins

You can install one or more plugins before startup by passing a comma-separated list of plugins.

    -e PLUGINS=ID[,ID]

In this example, it will install the Marvel plugin

    -e PLUGINS=elasticsearch/marvel/latest

Many more plugins [are available here](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/modules-plugins.html#known-plugins).

## Publish As

Since the container gives the Elasticsearch software an isolated perspective of its networking, it will most likely advertise its published address with a container-internal IP address. This can be overridden with a physical networking name and port using:

    -e PUBLISH_AS=DOCKERHOST:9301

_Author Note: I have yet to hit a case where this was actually necessary. Other
than the cosmetic weirdness in the logs, Elasticsearch seems to be quite tolerant._

## Node Name

Rather than use the randomly assigned node name, you can indicate a specific one using:

    -e NODE_NAME=Docker

## Node Type

If you refer to [the Node section](https://www.elastic.co/guide/en/elasticsearch/reference/2.3/modules-node.html)
of the Elasticsearch reference guide, you'll find that there's three main types of nodes: master-eligible, data, and client.

In larger clusters it is important to dedicate a small number (>= 3) of master nodes. There are also cases where a large cluster may need dedicated gateway nodes that are neither master nor data nodes and purely operate as "smart routers" and have large amounts of CPU and memory to handle client requests and search-reduce.

To simplify all that, this image provides a `TYPE` variable to let you amongst these combinations. The choices are:

* (not set, the default) : the default node type which is both master-eligible and a data node
* `MASTER` : master-eligible, but holds no data. It is good to have three or more of these in a
large cluster
* `DATA` (or `NON_MASTER`) : holds data and serves search/index requests. Scale these out for elastic-y goodness.
* `GATEWAY` : only operates as a client node or a "smart router". These are the ones whose HTTP port 9200 will need to be exposed

A [Docker Compose](https://docs.docker.com/compose/overview/) file will serve as a good example of these three node types:

```
version: '2'

services:
  gateway:
    image: itzg/elasticsearch
    environment:
      UNICAST_HOSTS: master
      TYPE: GATEWAY
    ports:
      - "9200:9200"

  master:
    image: itzg/elasticsearch
    environment:
      UNICAST_HOSTS: gateway
      TYPE: MASTER
      MIN_MASTERS: 2

  data:
    image: itzg/elasticsearch
    environment:
      UNICAST_HOSTS: master,gateway
      TYPE: DATA
```

## Minimum Master Nodes

In combination with the `TYPE` variable above, you will also want to configure the minimum master nodes to [avoid split-brain](https://www.elastic.co/guide/en/elasticsearch/reference/2.3/modules-node.html#split-brain) during network outages.

The minimum, which can be calculated as `(master_eligible_nodes / 2) + 1`, can be set with the `MIN_MASTERS` variable.

Using the Docker Compose file above, a value of `2` is appropriate when scaling the cluster to 3 master nodes:

    docker-compose scale master=3

## Auto transport/http discovery with Swarm Mode

When using Docker Swarm mode (starting with 1.12), the overlay and ingress network interfaces are assigned
multiple IP addresses. As a result, it creates confusion for the transport publish logic even when using
the special value `_eth0_`.

To resolve this, add

    -e DISCOVER_TRANSPORT_IP=eth0

replacing `eth0` with another interface within the container, if needed.

The same can be done for publish/binding of the http module by adding:

    -e DISCOVERY_HTTP_IP=eth2
