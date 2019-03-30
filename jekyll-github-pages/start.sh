#!/bin/sh

if [ `ls /site/index.* 2> /dev/null | wc -l` = 0 ]; then
  echo "Preparing /site with default content..."
  cp -r /site-template/* /site
fi

if [ ! -e /site/Gemfile ]; then
  cp /tmp/Gemfile /site/Gemfile
fi

cd /site
bundle exec jekyll serve
