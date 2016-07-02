#!/bin/bash

apply_base_data() {
  contents=`ls $GITBLIT_BASE_FOLDER|wc -l`

  if [ $contents = "0" ]; then
    cp -r $GITBLIT_PATH/data/* $GITBLIT_BASE_FOLDER
  fi
}

apply_config() {
    cp -rf /config/* $GITBLIT_BASE_FOLDER
}

create_repo() {
  local repo_dir=$GITBLIT_BASE_FOLDER/git/$1.git
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

  echo "
CREATING repository '$1' with:
* read/clone access for all
* push access for authenticated users"

  RET="file://$repo_dir"
}

apply_repos() {
  for rdir in /repos/*; do
    if [ -e $rdir/.git ]; then
      r=$(basename $rdir)
      create_repo $r
      local url=$RET
      cd $rdir
      echo "* pushed existing content"
      git push --all $url
    fi

  done
}

create_initial_repo() {
  if [ -d $GITBLIT_INITIAL_REPO ]; then
    return
  fi

  create_repo $GITBLIT_INITIAL_REPO
}

shopt -s nullglob
if [ ! -f /var/local/gitblit_firststart ]; then
    FIRSTSTART=1
else
    FIRSTSTART=0
fi

if [ $FIRSTSTART = 1 ]; then
  apply_base_data

  echo "
Applying configuration from /config
"
  apply_config
  touch /var/local/gitblit_firststart
fi


if [[ -n $GITBLIT_INITIAL_REPO ]]; then
  create_initial_repo
fi
apply_repos

cd $GITBLIT_PATH
$JAVA_HOME/bin/java -jar $GITBLIT_PATH/gitblit.jar \
  --httpsPort $GITBLIT_HTTPS_PORT --httpPort $GITBLIT_HTTP_PORT \
  --baseFolder $GITBLIT_BASE_FOLDER
