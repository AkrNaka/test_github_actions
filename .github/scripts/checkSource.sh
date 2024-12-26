#!/bin/bash

# 引数を変数に代入
changed_files=$1

# エラーフラグ
failed=false

# 変更行ごとにループ
for line in $changed_files; do
  # ファイル名と行番号を分割
  file=$(echo "$line" | cut -d':' -f1)
  line_num=$(echo "$line" | cut -d':' -f2)

  ~/.composer/vendor/bin/phpcs --standard=PSR12 $file

  if grep -q "^[ ]\{1,2\}$line_num |" tmp.txt; then
    echo "Error detected on line $line_num in file $file"
    echo "$file:$line_num" >> a.txt
    grep "^[ ]\{1,2\}$line_num |" tmp.txt >> a.txt
    failed=true
  fi
done

cat tmp.txt

# エラーが発生していた場合、ジョブを失敗として終了
if [ "$failed" = true ]; then
  echo "PHP CodeSniffer found issues on modified lines."
  cat tmp.txt
  cat a.txt
  # ワークフローをエラーとして終了
  exit 1
else
  echo "No issues found in modified lines."
fi

exit 0
