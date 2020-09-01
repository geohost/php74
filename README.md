# php74
Dockerfile for DockerHub: geohost/php74
Container based on Ubuntu 20.04 with php7.4-fpm or cron
If the container was started with the env IS_CRON=1 make it only run the cron daemon
or with env IS_SUPERVISOR=1 will start the supervisord.   
