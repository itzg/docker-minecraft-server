
Provides a ready-to-run [Kibana](http://www.elasticsearch.org/overview/kibana/) server that can
easily hook into your [Elasticsearch containers](https://registry.hub.docker.com/u/itzg/elasticsearch/).

## Usage with Docker elasticsearch container

This is by far the easiest and most Docker'ish way to run Kibana.

Assuming you started one or more containers using something like

    docker run -d --name your-es -p 9200:9200 itzg/elasticsearch

Start Kibana using

    docker run -d -p 5601:5601 --link your-es:es itzg/kibana

Proceed to use Kibana starting from 
[this point in the documentation](http://www.elasticsearch.org/guide/en/kibana/current/access.html)

## Usage with non-Docker elasticsearch

Start Kibana using

    docker run -d -p 5601:5601 -e ES_URL=http://YOUR_ES:9200 itzg/kibana

Replacing `http://YOUR_ES:9200` with the appropriate URL for your system.
