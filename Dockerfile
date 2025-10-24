FROM --platform=linux/amd64 9hitste/app:latest

# Устанавливаем приложение (базовый образ уже это делает)
# Затем копируем конфиги поверх установленных
COPY config/ /etc/9hitsv3-linux64/config/

CMD ["/nh.sh", "--token=701db1d250a23a8f72ba7c3e79fb2c79", "--mode=bot", "--allow-crypto=no", "--hide-browser", "--schedule-reset=1", "--cache-del=200"]
