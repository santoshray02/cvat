#!/usr/bin/env bash

redis-server --port 18002 &
python manage.py rqworker --worker-class rq_win.WindowsWorker -v 3 default &

python manage.py rqworker --worker-class rq_win.WindowsWorker -v 3 low &

rqscheduler -i 30 -p 18002 &

cp -r cvat-ui/dist/* nginx/html/

python manage.py migrate && \
    python manage.py collectstatic --no-input && \
    exec python manage.py runserver 0.0.0.0:18001 &

cd nginx && ./nginx &