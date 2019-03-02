docker run -it --rm \
    -v /docker-volumes/letsencrypt/etc/letsencrypt:/etc/letsencrypt \
    -v /docker-volumes/letsencrypt/var/lib/letsencrypt:/var/lib/letsencrypt \
    -v /docker-src/letsencrypt/site:/data/letsencrypt \
    -v "/docker-volumes/letsencrypt/var/log/letsencrypt:/var/log/letsencrypt" \
    certbot/certbot \
    certonly --webroot \
    --agree-tos \
    --webroot-path=/data/letsencrypt \
    --staging \
    -d kiwigaming.de