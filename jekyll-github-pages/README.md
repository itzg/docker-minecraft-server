This container is pre-configured according to the 
[GitHub Pages use of Jekyll](https://help.github.com/articles/using-jekyll-with-pages).

It serves up the generated content on port 4000 and the site is generated from
the container's `/site` volume. You can either bring your own site content or
let it generate some VERY simple content along with the standard Jekyll directory
layout.

A typical way to run this:

    docker run -it -p 4000:4000 -v $(pwd)/site:/site itzg/jekyll-github-pages

where either it will load your content or initialize the content under
`site` in your current working directory.
