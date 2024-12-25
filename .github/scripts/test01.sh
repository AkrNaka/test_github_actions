#!/bin/sh

# 引数を変数に代入
file=$1

# phpcsのインストール
composer global require "squizlabs/php_codesniffer=*"
# phpcsの実行
~/.composer/vendor/bin/phpcs $file

exit 0
