#!/bin/bash

# 使用範例: ./create-site.sh ideambox.cc ideambox
# ./create-site.sh newdomain.com newfolder


DOMAIN="$1"
# 使用 Bash 內建字串處理：取得第一個點（.）前的部分
prefix="${DOMAIN%%.*}"
echo "domain:$DOMAIN"
# 如果第二個參數沒給，就預設用 prefix
FOLDER="$2"
if [ -z "$FOLDER" ]; then
    FOLDER="$prefix"
fi
echo "folder:$FOLDER"
# FOLDER=$2
NGINX_SITE_PATH="./nginx/sites"
WWW_PATH="./www"

if [ -z "$DOMAIN" ] || [ -z "$FOLDER" ]; then
  echo "🚀Usage: ./create-site.sh yourdomain.com foldername"
  exit 1
fi

# 建立網站資料夾
mkdir -p ${WWW_PATH}/${FOLDER}

# 建立 Nginx 設定檔
sed "s/__DOMAIN__/${DOMAIN}/g; s/__FOLDER__/${FOLDER}/g" ./nginx/template.conf > ${NGINX_SITE_PATH}/${DOMAIN}.conf

# 建立 symlink（容器內或 host 端做）
# docker exec nginx 
ln -s ./nginx/sites/${DOMAIN}.conf ./nginx/sites-enabled/${DOMAIN}.conf

# 申請憑證（host 端）
# sudo certbot certonly --standalone -d ${DOMAIN}

# 重啟容器
docker-compose restart nginx

echo "✅ 網站 ${DOMAIN} 已建立並啟用！"
