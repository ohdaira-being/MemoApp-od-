require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'json'
require 'rack/contrib'
require 'securerandom'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end

  # データの保存
  def save_data(id, new_head, new_comment)
    @hash = JSON.parse(File.read('memodata.json'))
    @hash[id] = { 'head_data' => new_head, 'comment_data' => new_comment }
    File.open('memodata.json', 'w') { |f| JSON.dump(@hash, f) }
  end

  # memosのデータの呼び出し
  def load_data(id)
    JSON.parse(File.read('memodata.json'))["#{id}"]
  end

  # memoの削除
  def delete_data(delete_id)
    @delete_memo = JSON.parse(File.read('memodata.json'))
    @delete_memo.delete("#{delete_id}")
    File.open('memodata.json', 'w') { |f| JSON.dump(@delete_memo, f) }
  end
end

get '/memos' do
  @hash = JSON.parse(File.read('memodata.json'))
  erb :memolist
end

get '/memos/newmemo' do
  erb :addmemo
end

post '/memos' do
  id = SecureRandom.uuid
  new_head = params[:new_head]
  new_comment = params[:new_comment]
  save_data(id, new_head, new_comment)
  erb :memolist
end

get '/memos/:id' do
  @path = params[:id]
  @memo = load_data(@path)
  erb :showmemo
end

delete '/memos/:id' do
  @path = params[:id]
  delete_data(@path)
  redirect to('/memos')
  erb :memolist
end

get '/memos/:id/editmemo' do
  @path = params[:id]
  @memo = load_data(@path)
  erb :editmemo
end

patch '/memos/:id' do
  @path = params[:id]
  new_head = params[:edithead]
  new_comment = params[:editcomment]
  save_data(@path, new_head, new_comment)
  @memo = load_data(@path)
  erb :showmemo
end
