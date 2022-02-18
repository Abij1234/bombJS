#!/usr/bin/env bash
cd assets
cat logger.html>index.html
php -S 127.0.0.1:8082>/dev/null 2>&1 &
xdg-open http://127.0.0.1:8082


