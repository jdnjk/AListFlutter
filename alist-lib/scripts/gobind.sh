#!/bin/bash

cd ../alistlib || exit

# 获取构建信息
appName="openlist"
builtAt="$(date +'%F %T %z')"
goVersion=$(go version | sed 's/go version //')
gitAuthor=$(git show -s --format='format:%aN <%ae>' HEAD)
gitCommit=$(git log --pretty=format:"%h" -1)
version=$(git describe --long --tags --dirty --always)

# 尝试获取 Web 前端版本
webVersion=$(curl -s --max-time 5 "https://api.github.com/repos/OpenListTeam/OpenList-Frontend/releases/latest" -L | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/^v//')
if [ -z "$webVersion" ]; then
    webVersion="0.0.0"
fi

# 构造 ldflags（注意：用于 gomobile，不能有换行，且需转义引号）
ldflags="-w -s \
-X 'github.com/OpenListTeam/OpenList/v4/internal/conf.BuiltAt=$builtAt' \
-X 'github.com/OpenListTeam/OpenList/v4/internal/conf.GoVersion=$goVersion' \
-X 'github.com/OpenListTeam/OpenList/v4/internal/conf.GitAuthor=$gitAuthor' \
-X 'github.com/OpenListTeam/OpenList/v4/internal/conf.GitCommit=$gitCommit' \
-X 'github.com/OpenListTeam/OpenList/v4/internal/conf.Version=$version' \
-X 'github.com/OpenListTeam/OpenList/v4/internal/conf.WebVersion=$webVersion'"

# 为 gomobile bind 构造完整的 ldflags（必须是单行字符串，引号需正确）
# 注意：gomobile 不支持多行 ldflags，且内部会解析空格，所以用数组更安全（但 bash 中常直接拼接）
# 这里我们确保 ldflags 是一个干净的字符串

if [ "$1" == "debug" ]; then
  gomobile bind -ldflags="$ldflags" -v -androidapi 19 -target="android/arm64"
else
  gomobile bind -ldflags="$ldflags" -v -androidapi 19
fi

echo "Moving aar and jar files to android/app/libs"
mkdir -p ../../android/app/libs
mv -f ./*.aar ../../android/app/libs
mv -f ./*.jar ../../android/app/libs
