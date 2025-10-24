FROM 9hitste/app

# Устанавливаем необходимые утилиты
RUN apt-get update && apt-get install -y python3 wget tar

# Скачиваем архив с GitHub (используем ваш рабочий URL)
RUN wget -q -O /tmp/main.tar.gz https://github.com/atrei73/9hits-project_2/archive/main.tar.gz

# Распаковываем архив и копируем папку config
RUN tar -xzf /tmp/main.tar.gz -C /tmp && \
    mkdir -p /etc/9hitsv3-linux64 && \
    cp -r /tmp/9hits-project_2-main/config/* /etc/9hitsv3-linux64/

# Создаём health-check скрипт
RUN echo "from http.server import BaseHTTPRequestHandler, HTTPServer\nclass handler(BaseHTTPRequestHandler):\n    def do_GET(self):\n        self.send_response(200)\n        self.end_headers()\n        self.wfile.write(b'OK')\nHTTPServer(('', 8080), handler).serve_forever()" > /health.py

# Запускаем приложение и health-check
CMD ["sh", "-c", "python3 /health.py & /nh.sh --token=701db1d250a23a8f72ba7c3e79fb2c79 --mode=bot --allow-crypto=no --hide-browser --schedule-reset=1 --cache-del=200 --create-swap=10G"]
