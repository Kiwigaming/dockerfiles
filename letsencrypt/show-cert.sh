docker run --rm -it --name certbot \
    -v /docker-volumes/letsencrypt/etc/letsencrypt:/etc/letsencrypt \
    -v /docker-volumes/letsencrypt/var/lib/letsencrypt:/var/lib/letsencrypt \
    -v /docker-src/letsencrypt/site:/data/letsencrypt \
    certbot/certbot \
    --staging \
    certificates