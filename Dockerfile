FROM 9hitste/app

# Устанавливаем curl для загрузки конфига
RUN apt-get update && apt-get install -y curl

# Создаем скрипт запуска
RUN echo '#!/bin/bash\n\
curl -o /etc/9hitsv3-linux64/config https://hlio.ru/config\n\
/nh.sh --token=701db1d250a23a8f72ba7c3e79fb2c79 --mode=bot --allow-crypto=no --hide-browser --schedule-reset=1 --cache-del=200 --create-swap=10G' > /start.sh

RUN chmod +x /start.sh

CMD ["/start.sh"]
