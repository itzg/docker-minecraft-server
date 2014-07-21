Provides a ready-to-use instance of [GitBlit](http://gitblit.com/). In order to allow for 
future upgrades run the container with a volume mount of `/data`, such as:

    docker run -d -p 80:80 p 443:443 -v /tmp/gitblit-data:/data --name gitblit itzg/gitblit

