#!/bin/bash

apply_base_data() {
  contents=`ls $GITBLIT_BASE_FOLDER|wc -l`

  if [ $contents = "0" ]; then
    cp -r $GITBLIT_PATH/data/* $GITBLIT_BASE_FOLDER
  fi
}

apply_config() {
  for p in /config/*.properties; do
    echo "
APPLYING configuration file $p
"
    cp $p $GITBLIT_BASE_FOLDER
    mv $p ${p}.applied
  done
}

create_initial_repo() {
  if [ -d $GITBLIT_INITIAL_REPO ]; then
    return
  fi

  echo "
CREATING initial repository '$GITBLIT_INITIAL_REPO' with:
* read/clone access for all
* push access for authenticated users
"

  local repo_dir=$GITBLIT_BASE_FOLDER/git/${GITBLIT_INITIAL_REPO}.git
  mkdir -p $repo_dir
  cd $repo_dir

  git init --bare
  
  echo "
[gitblit]
        description =
        originRepository =
        owner = $GITBLIT_ADMIN_USER
        acceptNewPatchsets = true
        acceptNewTickets = true
        mergeTo = master
        useIncrementalPushTags = false
        allowForks = true
        accessRestriction = PUSH
        authorizationControl = AUTHENTICATED
        verifyCommitter = false
        showRemoteBranches = false
        isFrozen = false
        skipSizeCalculation = false
        skipSummaryMetrics = false
        federationStrategy = FEDERATE_THIS
        isFederated = false
        gcThreshold =
        gcPeriod = 0
" >> config

  git config --replace-all core.logallrefupdates false

  cd $GITBLIT_PATH
}

shopt -s nullglob
apply_base_data

if [ -d /config ]; then
  apply_config
fi

if [[ -n $GITBLIT_INITIAL_REPO ]]; then
  create_initial_repo
fi

$JAVA_HOME/bin/java -jar $GITBLIT_PATH/gitblit.jar \
  --httpsPort $GITBLIT_HTTPS_PORT --httpPort $GITBLIT_HTTP_PORT \
  --baseFolder $GITBLIT_BASE_FOLDER

