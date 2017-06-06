#!/bin/sh

set -e

if [[ -d "$PUPPET_REPO_PATH" ]] && ! git --git-dir=$PUPPET_REPO_PATH/.git remote get-url origin | grep --quiet $PUPPET_REPO; then
  echo "Git repo in $PUPPET_REPO_PATH doesn't match the one provided ($PUPPET_REPO)"
  if [[ "$PUPPET_REPO_PATH" -eq "puppet" ]]; then
    echo "I'll delete $PUPPET_REPO_PATH and clone it again from $PUPPET_REPO"
    rm -rf $PUPPET_REPO_PATH
  else
    echo "Please provide the correct puppet repository path"
    exit 1
  fi
fi
if [[ ! -d "$PUPPET_REPO_PATH" ]]; then
  echo "Cloning $PUPPET_REPO into $PUPPET_REPO_PATH"
  git clone -b $GIT_BRANCH $PUPPET_REPO puppet
fi

cd $PUPPET_REPO_PATH

echo "Fetching new commits for branch $GIT_BRANCH"
git fetch && git checkout $GIT_BRANCH && git pull && git submodule update --init --recursive
