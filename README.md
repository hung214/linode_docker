# Ubuntu24.04 內 docker建立nginx+php7.1+php8.1+mysql8+redis
主要是為了方便自己快速架設本地網站開發用的，支援mac、Ubuntu linux環境

## 建立docker專案
1. 先把 .env-example 改成 .env ，開啟檔案後設定 DocumentRoot(網頁專案路徑)
MySQLRootPassword(MySql密碼)
Timezone(時區設定)


2. 建立專案執行下面命令
```bash
docker-compose up -d
```
### 建立站點：
1. 使用終端機執行命令
```BASH
# sudo sh create-site.sh <網域名稱>
sudo sh create-site.sh happy.com
```
> 1. 執行之後會在./nginx/sites/增加happy.conf
> 2. 會在專案資料夾外層www/wwwroot/建立happy資料夾

如果網站專案資料夾路徑有錯誤需要修改 .env, create-site.sh


## WP需要修正內容
### 查詢容器UID並修改資料夾權限，修改後資料夾才能增加
步驟１：
```bash
# docker exec -it <容器名稱> id www-data
docker exec -it php81 id www-data
# 顯示類似 uid=1000(www-data) gid=33(www-data) groups=33(www-data)
```
步驟２：
```bash
# 把uid用到下面命令： sudo chown -R <uid>:www-data ./
# 確定資料夾位置為www或是html根目錄執行
chown -R 1000:www-data ./網頁資料夾
# 或者進到 docker exec -it php81 /bin/bash 裡面
docker exec -it php81 /bin/bash
chown -R 1000:www-data /var/www/html
```
步驟３：在 wp-config.php 增加
```php
define('FS_METHOD', 'direct');
```
全部完成後才能處理下面的內容
1. 安裝外掛
2. 可增加資料夾
3. 備份才能正常還原



## 如果需要申請憑證
1. 主機安裝certbot
```bash
sudo apt update
sudo apt install certbot
```

2. 可設定執行排程
使用以下指令編輯 cron 排程表：
```bash
sudo crontab -e
```
加入以下排程：
```bash
0 3 * * * certbot renew --quiet --deploy-hook "docker restart nginx"
＃修改為
0 3 * * * docker stop nginx && certbot renew --webroot -w /www/wwwroot/happy --quiet >> /var/log/certbot_renew.log 2>&1 && docker start nginx
```
這條會每天凌晨 3:00 自動嘗試續約，成功後重啟 nginx。


🔧 如果你想「明確知道剩幾天」？

你可以加入這條指令來看剩下幾天（非續約，只是查看）：
```bash
certbot certificates
```
它會列出所有憑證與剩餘天數，如：
```bash
Certificate Name: abc.com
    Domains: abc.com www.abc.com
    Expiry Date: 2025-06-05 12:00:00+00:00 (VALID: 59 days)
    Certificate Path: /etc/letsencrypt/live/abc.com/fullchain.pem
```
## 自動化建立站點包含ssl申請（linux環境有效）
```bash
# 到docker資料夾內
cd docker
# 執行批次檔
sh create-site.sh abc.com
```
必須要注意，資料夾建立的位置，可以視狀況調整檔案

如果要刪除憑證
```bash
# 確認名稱
sudo certbot certificates

# 刪除憑證
sudo certbot delete --cert-name my-old-site.com
```
## temp資料夾是為了還不知道要放什麼的樣板
裡面放了WordPress設定檔：
1. wp-config-example.php