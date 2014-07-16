#!/bin/sh

contents=`ls $GITBLIT_BASE_FOLDER|wc -l`

if [ $contents = "0" ]; then
  cp -r $GITBLIT_PATH/data/* $GITBLIT_BASE_FOLDER
fi

$JAVA_HOME/bin/java -jar $GITBLIT_PATH/gitblit.jar --httpsPort $GITBLIT_HTTPS_PORT --httpPort $GITBLIT_HTTP_PORT --baseFolder $GITBLIT_BASE_FOLDER

