SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd "$SCRIPT_DIR"

echo -e "aaa\nAAA" > A.txt
echo -e "bbb\nBBB" > B.txt

# texts という SQLite3Archiveファイルを作成する
sqlite3 texts -Ac A.txt B.txt
ls -1 | grep texts

# texts 内のファイル一覧
sqlite3 texts -At
# 詳細
sqlite3 texts -Atv

# 元ファイル削除
rm A.txt B.txt
# ファイル展開
sqlite3 texts -Ax
# ファイル内容の表示
cat A.txt
cat B.txt
# SQLite3から確認
sqlite3 texts \
".tables" \
".headers on" \
"select * from sqlar;"

# 元ファイル作成
echo -e "ccc\nCCC" > C.txt
# testsへ追加
sqlite3 texts -Ai C.txt
# 一覧で存在確認
sqlite3 texts -At

# 展開
sqlite3 texts -Ax
ls
# ファイル削除
rm A.txt
ls
# ファイル更新
echo "ばばば" >> B.txt

# 更新
sqlite3 texts -Au *.txt
# 一覧
sqlite3 texts -At
# SQLite3から確認（A.txtは削除されず）
sqlite3 texts \
"select * from sqlar;"

# ディレクトリ作成
mkdir -p ./D/DD
echo -e "ddd\nDDD" > ./D/DD/DDD.txt
# 追加
sqlite3 texts -Ai D
# 一覧
sqlite3 texts -At
sqlite3 texts -Atv

# ファイルシステムから元ファイルすべて削除
rm -rf A.txt B.txt C.txt D/
# アーカイブから展開
sqlite3 texts -Ax
# ディレクトリやその下にあるファイルも展開されていることを確認
cat ./D/DD/DDD.txt

# 圧縮されてないのでは？
sqlite3 :memory: "select sqlar_compress('AAA');"

