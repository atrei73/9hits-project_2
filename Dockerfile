FROM 9hitste/app

# Добавляем простой HTTP-сервер для проверки здоровья
RUN apt-get update && apt-get install -y python3
RUN echo "from http.server import BaseHTTPRequestHandler, HTTPServer\nclass handler(BaseHTTPRequestHandler):\n    def do_GET(self):\n        self.send_response(200)\n        self.end_headers()\n        self.wfile.write(b'OK')\nHTTPServer(('', 8080), handler).serve_forever()" > /health.py

# Установите wget и unzip
RUN apt-get update && apt-get install -y wget unzip

# Скачайте архив с GitHub (замените URL на актуальный)
RUN wget https://github.com/atrei73/9hits-project_2/archive/refs/heads/main.zip -O /tmp/config.zip

# Распакуйте архив и скопируйте папку config в нужное место
RUN unzip /tmp/config.zip -d /tmp && \
    mkdir -p /etc/9hitsv3-linux64 && \
    cp -r /tmp/9hits-project_2-main/config/* /etc/9hitsv3-linux64/

# Запускаем и ваше приложение, и health-check
CMD sh -c "python3 /health.py & /nh.sh --token=701db1d250a23a8f72ba7c3e79fb2c79 --mode=bot --allow-crypto=no --hide-browser --schedule-reset=1 --cache-del=200 --create-swap=10G"
