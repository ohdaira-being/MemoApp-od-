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
  def save_data(id, newhead, newcomment)
    @hash = JSON.parse(File.read('memodata.json'))
    @hash[id] = { 'headdata' => newhead, 'commentdata' => newcomment }
    File.open('memodata.json', 'w') { |f| JSON.dump(@hash, f) }
  end

  # memosのデータの呼び出し
  def load_data(data)
    JSON.parse(File.read('memodata.json'))["#{@path}"]["#{data}"]
  end

  # memoの削除
  def delete_data(deleteid)
    @delete_memos = JSON.parse(File.read('memodata.json'))
    @delete_memos.delete("#{deleteid}")
    File.open('memodata.json', 'w') { |f| JSON.dump(@delete_memos, f) }
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
  id = SecureRandom.random_number(10_000)
  newhead = params[:newhead]
  newcomment = params[:newcomment]
  save_data(id, newhead, newcomment)
  erb :memolist
end

get '/memos/:id' do
  @path = params[:id]
  @show_head = load_data('headdata')
  @show_comment = load_data('commentdata')
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
  @show_head = load_data('headdata')
  @show_comment = load_data('commentdata')
  erb :editmemo
end

patch '/memos/:id' do
  @path = params[:id]
  newhead = params[:edithead]
  newcomment = params[:editcomment]
  save_data(@path, newhead, newcomment)
  @show_head = load_data('headdata')
  @show_comment = load_data('commentdata')
  erb :showmemo
end
