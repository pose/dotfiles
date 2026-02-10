#!/usr/bin/env bash

set -euo pipefail

if !  git config --get user.email; then
  # Git commit config
  printf 'Name for git commits (ie. John Foo): '
  read GIT_NAME
  printf 'Email for git commits (john.foo@example.com): '
  read GIT_EMAIL

# Configure git
printf "Set git config to use %s <%s>? [y/n]: " "$GIT_NAME" "$GIT_EMAIL"
read reply
if [[ $reply =~ ^[Yy]$ ]]
then
  git config --global user.name "$GIT_NAME"
  git config --global user.email "$GIT_EMAIL"
fi
fi
