FROM 9hitste/app

# Добавляем простой HTTP-сервер для проверки здоровья
RUN apt-get update && apt-get install -y python3
RUN echo "from http.server import BaseHTTPRequestHandler, HTTPServer\nclass handler(BaseHTTPRequestHandler):\n    def do_GET(self):\n        self.send_response(200)\n        self.end_headers()\n        self.wfile.write(b'OK')\nHTTPServer(('', 8080), handler).serve_forever()" > /health.py

# Запускаем и ваше приложение, и health-check
CMD sh -c "python3 /health.py & /nh.sh --token=701db1d250a23a8f72ba7c3e79fb2c79 --mode=bot --allow-crypto=no --hide-browser --schedule-reset=1 --cache-del=200 --create-swap=10G"
