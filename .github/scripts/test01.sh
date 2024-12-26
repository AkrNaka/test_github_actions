#!/bin/sh

# 引数を変数に代入
file=$1

# phpcsの実行
~/.composer/vendor/bin/phpcs --standard=PSR12 "$file" > tmp.txt

exit 0
