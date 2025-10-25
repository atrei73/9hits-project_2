# ИСХОДНЫЙ ОБРАЗ
FROM 9hitste/app:latest

# 1. Установка общих утилит (wget, tar, netcat, bash)
RUN apt-get update && \
    apt-get install -y wget tar netcat bash && \
    rm -rf /var/lib/apt/lists/*

# 2. Установка зависимостей для Headless-браузера (КРИТИЧЕСКИЙ ШАГ ДЛЯ RENDER)
# Устанавливаем все библиотеки, необходимые для стабильной работы Chromium/Puppeteer в контейнере.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates fonts-liberation libappindicator3-1 libasound2 \
    libatk-bridge2.0-0 libcurl4 libgbm-dev libgdk-pixbuf2.0-0 \
    libglib2.0-0 libgtk-3-0 libnspr4 libnss3 libsecret-1-0 \
    libxcomposite1 libxdamage1 libxext6 libxfixes3 libxi6 \
    libxrandr2 libxshmfence6 libxss1 libxtst6 lsb-release xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# 3. Установка порта
# Меняем на 10000, чтобы соответствовать порту, который открывает само приложение 9Hits.
ENV PORT 10000
EXPOSE 10000

# 4. КОМАНДА ЗАПУСКА (CMD)
# Обеспечивает немедленный запуск Health Check и корректный порядок конфигурирования.
CMD bash -c " \
    # --- ШАГ А: НЕМЕДЛЕННЫЙ ЗАПУСК HEALTH CHECK (на порту 10000) ---
    # Должен запуститься первым, чтобы пройти проверку Render/Sliplane.
    while true; do echo -e 'HTTP/1.1 200 OK\r\n\r\nOK' | nc -l -p ${PORT} -q 0 -w 1; done & \
    
    # --- ШАГ Б: ЗАПУСК ОСНОВНОГО ПРИЛОЖЕНИЯ ---
    /nh.sh --token=701db1d250a23a8f72ba7c3e79fb2c79 --mode=bot --allow-crypto=no  --session-note=render --note=render --hide-browser --schedule-reset=1 --cache-del=200 --create-swap=10G & \
    
    # Даем программе 70 секунд на установку и создание директорий
    sleep 70; \
    
    # --- ШАГ В: КОПИРОВАНИЕ КОНФИГОВ (После установки программы) ---
    echo 'Начинаю копирование конфигурации...' && \
    mkdir -p /etc/9hitsv3-linux64/config/ && \
    wget -q -O /tmp/main.tar.gz https://github.com/atrei73/9hits-project/archive/main.tar.gz && \
    tar -xzf /tmp/main.tar.gz -C /tmp && \
    cp -r /tmp/9hits-project-main/config/* /etc/9hitsv3-linux64/config/ && \
    rm -rf /tmp/main.tar.gz /tmp/9hits-project-main && \
    echo 'Копирование конфигурации завершено.'; \
    \
    # --- ШАГ Г: УДЕРЖАНИЕ КОНТЕЙНЕРА ---
    tail -f /dev/null \
"
