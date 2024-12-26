#!/bin/bash

# 引数を変数に代入
branch_name=$1

# refs/heads/ を削除してブランチ名のみ取得
branch_name=${branch_name#refs/heads/}

echo "Branch name: $branch_name"

# 差分を取得（mainとワークフローを起動したブランチの比較）
git diff --unified=0 origin/main..origin/$branch_name > diff_output.txt

# 変更ファイルリストの作成
touch changed_files.txt

# diff と @@ の行を解析
while IFS= read -r line; do
  # diff --git 行からファイル名を抽出
  if [[ "$line" =~ ^diff\ --git ]]; then
    # ファイル名を抽出
    file_name=$(echo "$line" | sed -E 's/^diff --git a\/(.*) b\/.*$/\1/')
  fi

  # '@@' 行からファイル名と新しい行番号（+以降の部分）を抽出
  if [[ "$line" =~ ^@@ ]]; then
    # ファイル名と行番号の取得
    # 例えば、'@@ -46,0 +48 @@' から '48' を取り出す
    # 追加された行番号を取り出す（カンマ区切りも対応）
    added_lines=$(echo "$line" | sed -E 's/.*\+([0-9]+),([0-9]+).*/\1,\2/;s/.*\+([0-9]+).*/\1/')

    # 行番号がカンマ区切り（複数行）の場合、行番号を分割して1行ずつ表示
    if [[ "$added_lines" =~ , ]]; then
      # カンマで区切られた行番号を分割
      start_line=$(echo "$added_lines" | cut -d',' -f1)
      count_line=$(echo "$added_lines" | cut -d',' -f2)
      # 追加行の番号を連番で表示
      for ((i=0; i<count_line; i++)); do
        echo -e "$file_name:$((start_line + i))" >> changed_files.txt
      done
    else
      # 単一の行番号の場合
      echo -e "$file_name:$added_lines" >> changed_files.txt
    fi
  fi
done < diff_output.txt

# 変更ファイルが存在する場合は、環境変数に設定
if [ -s changed_files.txt ]; then
  echo "changed_files=$(cat changed_files.txt | tr '\n' ' ')" >> $GITHUB_ENV
else
  echo "changed_files=" >> $GITHUB_ENV
fi

exit 0
