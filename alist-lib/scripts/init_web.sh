#!/bin/bash

curl -L https://github.com/OpenListTeam/OpenList-Frontend/releases/download/rolling/openlist-frontend-dist-v4.1.1-de505e5.tar.gz -o dist.tar.gz
rm -rf ./dist
mkdir dist
tar -zxvf dist.tar.gz -C ./dist --strip-components=1
rm -rf ../public/dist
mv -f dist ../public
rm -rf dist.tar.gz
