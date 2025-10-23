FROM 9hitste/app

CMD ["/nh.sh", "--token=701db1d250a23a8f72ba7c3e79fb2c79", "--mode=bot", "--allow-crypto=no", "--hide-browser", "--schedule-reset=1", "--cache-del=200", "--create-swap=10G"]
