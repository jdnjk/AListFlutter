#!/bin/bash

curl -L https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v4.1.0/openlist-frontend-dist-lite-v4.1.0.tar.gz -o dist.tar.gz
rm -rf ./dist
mkdir dist
tar -zxvf dist.tar.gz -C ./dist --strip-components=1
rm -rf ../public/dist
mv -f dist ../public
rm -rf dist.tar.gz
