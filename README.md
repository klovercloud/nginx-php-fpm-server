**Docker Run**
```sh
docker run --rm -it --name=nginx-php -p 8080:8080 --user=1000 klovercloud/nginx-1.20.1-php7.4-fpm:debian-v1.0.0
```


**Docker Run as Non-Root and Readonly Filesystem**
```sh
docker run --rm -it --name=nginx-php -p 8080:8080 --user=1000 --read-only --tmpfs=/tmp -v /root/vol/nginx/run:/var/run/nginx --tmpfs=/var/cache/nginx --tmpfs=/var/log/nginx --tmpfs=/var/log --tmpfs=/run/php klovercloud/nginx-1.20.1-php7.4-fpm:stage-1-debian-v1.0.0
```
