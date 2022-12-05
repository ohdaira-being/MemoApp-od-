# README
## 立ち上げ方法
1. 以下のファイルをローカルにpullする。
- memo.rb
- Gemfile
- Gemfile.lock
- memodata.json
- layout.erb
- memolist.erb
- addmemo.erb
- showmemo.erb
- editmemo.erb

2. 次にviewsファルダーを作成し、「erbファイル」を入れる。
3. Rubyを扱えるコマンドプロンプトで「bundle install」を行い、「memo.rb」ファイルを実行する。（ruby memo.rb）

## 概要
1. フィヨルドブートキャンプの課題で製作した「メモ帳アプリ」です。
2. 保存形式は、「JSONファイル」への書き込みと読み込みです。
3. 以下4つの画面遷移を行い、メモの追加・削除・変更がをします。
- メモの一覧表示画面
- 新規メモの追加画面
- メモの詳細表示画面
- 既存メモの編集画面