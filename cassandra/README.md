Yet another Cassandra image, but this one got container and non-container access right.

# Basic Usage

To support access from both Docker containers and external, non-Docker clients:

    docker run -d --name cassandra -e PUBLISH_AS=192.168.59.103 -p 9160:9160 itzg/cassandra

replacing `192.168.59.103` with your Docker host's LAN IP address.
