#!/bin/bash
#set -x
# Use this variable to indicate a list of branches that docker hub is watching
branches_list=('openj9' 'openj9-11' 'openj9-nightly' 'adopt11' 'adopt13' 'adopt14' 'adopt15' 'multiarch' 'multiarch-latest')

function TrapExit {
  echo "Checking out back in master"
  git checkout master
}

batchMode=false

while getopts "hbt:s" arg
do
  case $arg in
    b)
      batchMode=true
      ;;
    t)
      tag=${OPTARG}
      ;;
    s)
      tagArgs="-s -m 'Signed during docker-versions-create"
      ;;
    h)
      echo "
Usage $0 [options]

Options:
  -b      enable batch mode, which avoids interactive prompts and causes script to fail immediately
          when any merge fails
  -t TAG  tag and push the current revision on master with the given tag
          and apply respective tags to each branch
  -s      enable signed tags
  -h      display this help and exit
"
      exit
      ;;
    *)
      echo "Unsupported arg $arg"
      exit 2
      ;;
  esac
done

${batchMode} && echo "Using batch mode"

trap TrapExit EXIT SIGTERM

test -d ./.git || { echo ".git folder was not found. Please start this script from root directory of the project!";
  exit 1; }

# Making sure we are in master
git checkout master
git pull --all || { echo "Can't pull the repo!"; \
  exit 1; }
if [[ $tag ]]; then
  git tag $tag
  git push origin $tag
fi

git_branches=$(git branch -a)

for branch in "${branches_list[@]}"; do
  if [[ "$git_branches" != *"$branch"* ]]; then
    echo "Can't update $branch because I can't find it in the list of branches."
    exit 1
  else
    echo "Branch $branch found. Working with it."
    git checkout "$branch" || { echo "Can't checkout into the branch. Don't know the cause."; \
      exit 1; }
    proceed='False'
    while [[ "$proceed" == "False" ]]; do
      # Ensure local branch is aligned with remote since docker-versions-create may have been run elsewhere
      git pull

      if git merge -m 'Auto-merging via docker-versions-create' master; then
        proceed="True"
        echo "Branch $branch updated to current master successfully"
        # pushing changes to remote for this branch
        git commit -m "Auto merge branch with master" -a
        # push may fail if remote doesn't have this branch yet. In this case - sending branch
        git push || git push -u origin "$branch" || { echo "Can't push changes to the origin."; exit 1; }
        if [[ $tag ]]; then
          git tag "$tag-$branch"
          git push origin "$tag-$branch"
        fi
      elif ${batchMode}; then
        status=$?
        echo "Git merge failed in batch mode"
        exit ${status}
        # and trap exit gets us back to master
      else
        cat<<EOL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Master merge in the branch $branch encountered an error!
You may try to fix the error and merge again. (Commit changes)
Or skip this branch merge completely.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
EOL
        printf "Should we try again? (y):"
        read -r answer
        if [[ "$answer" == '' ]] || [[ "$answer" == 'y' ]] || [[ "$answer" == 'Y' ]]; then
          # If you use non-local editor or files are changed in repo
          cat <<EOL

The following commands may encounter an error!
This is completely fine if the changes were made locally and remote branch doesn't know about them.

EOL
          # Updating branch from remote before trying again
          git checkout master
          git fetch --all
          git pull -a
          git checkout "$branch"
          continue
        else
          break
        fi
      fi
    done
  fi

done
