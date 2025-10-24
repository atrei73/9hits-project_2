FROM --platform=linux/amd64 9hitste/app:latest

# Проверим что образ вообще работает
CMD ["/bin/bash", "-c", "echo 'Container is starting...' && ls -la /etc/9hitsv3-linux64/ && /nh.sh --token=701db1d250a23a8f72ba7c3e79fb2c79 --mode=bot --allow-crypto=no --hide-browser --schedule-reset=1 --cache-del=200"]
