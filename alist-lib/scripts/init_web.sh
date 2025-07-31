#!/bin/bash

curl -L https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v4.1.0/openlist-frontend-dist-lite-v4.1.0.tar.gz -o dist.tar.gz
tar -zxvf dist.tar.gz
rm -rf ../public/dist
mv -f dist ../public
rm -rf dist.tar.gz