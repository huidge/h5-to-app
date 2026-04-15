#!/bin/bash
# 更新 H5 资源并同步到 Android 项目
set -e

BASE_URL="http://123.207.196.231:8080"
DIR="$(cd "$(dirname "$0")" && pwd)/web-assets"

echo ">>> 下载 H5 资源..."
curl -s "$BASE_URL/" -o "$DIR/index.html"
curl -s "$BASE_URL/vite.svg" -o "$DIR/vite.svg"

# 从 index.html 提取 JS 和 CSS 文件名
JS_FILE=$(grep -oE 'src="/assets/[^"]+' "$DIR/index.html" | sed 's/src="//')
CSS_FILE=$(grep -oE 'href="/assets/[^"]+' "$DIR/index.html" | sed 's/href="//')

[ -n "$JS_FILE" ] && curl -s "$BASE_URL$JS_FILE" -o "$DIR$JS_FILE"
[ -n "$CSS_FILE" ] && curl -s "$BASE_URL$CSS_FILE" -o "$DIR$CSS_FILE"

echo ">>> 资源下载完成"
echo ">>> 同步到 Android 和 iOS 项目..."
cd "$DIR/.." && npx cap sync

echo ">>> 完成! 现在可以重新构建:"
echo "    Android: Android Studio 或 cd android && ./gradlew assembleDebug"
echo "    iOS: Xcode (open ios/App/App.xcworkspace)"
