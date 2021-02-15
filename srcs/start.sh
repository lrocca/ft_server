#!/bin/bash

echo "<?php phpinfo(); ?>" >> /var/www/html/info.php

service nginx start
service php7.3-fpm start
service mysql start

bash
