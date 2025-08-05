echo "Generate 1-day cert."
openssl req -x509 -nodes -days 1 -newkey rsa:2048 -keyout nginx-oss/etc/ssl/nginx/1-day.key -out nginx-oss/etc/ssl/nginx/1-day.crt -subj "/CN=$NAME-NginxOneWorkshop"
echo "Generate 30-day cert."
openssl req -x509 -nodes -days 30 -newkey rsa:2048 -keyout nginx-oss/etc/ssl/nginx/30-day.key -out nginx-oss/etc/ssl/nginx/30-day.crt -subj "/CN=$NAME-NginxOneWorkshop"
echo "copy certs to lab5 for future labs"
cp nginx-oss/etc/ssl/nginx/1-day.* ../lab5/nginx-oss/etc/ssl/nginx/
cp nginx-oss/etc/ssl/nginx/30-day.* ../lab5/nginx-oss/etc/ssl/nginx/