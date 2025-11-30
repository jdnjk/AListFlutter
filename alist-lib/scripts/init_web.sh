#!/bin/bash

set -e

REPO="OpenListTeam/OpenList-Frontend"
LATEST_API="https://api.github.com/repos/$REPO/releases/latest"

ASSET_URL=$(curl -s "$LATEST_API" | \
  grep -o '"browser_download_url": "[^"]*openlist-frontend-dist-lite-[^"]*\.tar\.gz"' | \
  head -n1 | \
  sed 's/.*"\(.*\)".*/\1/')

if [ -z "$ASSET_URL" ]; then
  echo "Failed to find 'openlist-frontend-dist-lite-*.tar.gz' in latest release"
  exit 1
fi

curl -L --progress-bar "$ASSET_URL" -o dist.tar.gz

# 解压
rm -rf ./dist
mkdir -p ./dist
tar -zxvf dist.tar.gz -C ./dist --strip-components=1

# 移动到 public 目录
rm -rf ../public/dist
mv ./dist ../public/

# 清理
rm -rf dist.tar.gz ./dist
