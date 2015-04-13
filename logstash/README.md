This image bundles the latest (1.5.x) version of Logstash with the ability to
groom its own Elasticsearch indices.

# Basic Usage

To start a Logstash container, setup a directory on your host with one or more Logstash
pipeline configurations files, called `$HOST_CONF` here, and run

    docker run -d -v $HOST_CONF:/conf itzg/logstash

# Accessing host logs

Logstash is much more useful when it is actually processing...logs. Logs inside the container
are non-existent, but you can attach the host machine's `/var/log` directory via the container's
`/logs` volume:

    docker run ... -v /var/log:/logs ...

Keep in mind you will need to configure `file` inputs with a base path of `/logs`, such as

```
file {
  path => ['/logs/syslog']
  type => 'syslog'
}
```

# Receiving input from collectd

To allow for incoming [collectd](https://collectd.org/) content, **UDP** port 25826 is exposed and
can be mapped onto the host using:

    docker run ... -p 25826:25826/udp

Regardless of the host port, be sure to configure the logstash input to bind at port `25826`, such
as

```
udp {
  port => 25826
  codec => collectd { }
  buffer_size => 1452
}
```
