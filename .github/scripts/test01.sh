#!/bin/sh

ls
pwd
echo "testしてみたよ"
composer global require "squizlabs/php_codesniffer=*"
~/.composer/vendor/bin/phpcs ./product.php
exit 0