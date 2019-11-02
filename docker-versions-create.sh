#!/bin/bash
#set -x
# Use this variable to indicate a list of branches that docker hub is watching
branches_list=('openj9' 'another_name')

function TrapExit {
  echo "Checking out back in master"
  git checkout master
}

trap TrapExit EXIT SIGTERM

test -d ./.git || { echo ".git folder was not found. Please start this script from root directory of the project!";
  exit 1; }

# Making sure we are in master
git checkout master
#Updating git branch list. Cause the branch may be created from diff place
# Are tags in use? if not - remove --tags
git fetch --all --tags || { \
  echo "Can't fetch changes from the remote. Permissions?"; \
  exit 1; }
# Updating current master from remote. Cause repo could be changed
git merge origin/master || { echo "Can't update local master from remote repo!"; \
  exit 1; }

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
      if git merge master; then
        proceed="True"
        echo "Branch $branch updated to current master successfully"
        # pushing changes to remote for this branch
        git commit -m "Auto merge branch with master" -a
        # push may fail if remote doesn't have this branch yet. In this case - sending branch
        git push || git push -u origin "$branch" || { echo "Can't push changes to the origin."; exit 1; }
      else
        cat<<EOL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Master merge in the branch $branch encountered an error!
You may try to fix the error and merge again. (Commit changes)
Or skip this branch merge completely.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
EOL
        printf "Should we try again? (y):"
        read answer
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
