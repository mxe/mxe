#!/usr/bin/env bash

set -ue

git config --global user.email 'mxebot@gmail.com'
git config --global user.name 'MXEBot as Travis CI'
git config --global push.default simple
git config credential.helper "store --file=.git/credentials"
echo "https://${GH_TOKEN}:@github.com" > .git/credentials
git remote set-url origin 'https://github.com/mxe/mxe.git'
git commit -a -m 'Update packages.json & build-matrix.html' || true
git push origin HEAD:master
