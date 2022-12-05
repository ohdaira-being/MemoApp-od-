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
  def savedata(id, newhead, newcomment)
    @hash = File.open('memodata.json', 'r') { |f| JSON.load(f) }
    @hash[id] = { 'headdata' => newhead, 'commentdata' => newcomment }
    File.open('memodata.json', 'w') { |f| JSON.dump(@hash, f) }
  end

  # memosのデータの呼び出し
  def loaddata(data)
    File.open('memodata.json') do |f|
      JSON.load(f)[$path][data]
    end
  end

  # memoの削除
  def deletedata(deleteid)
    @delete_memos = File.open('memodata.json') { |f| JSON.load(f) }
    @delete_memos.delete("#{deleteid}")
    File.open('memodata.json', 'w') { |f| JSON.dump(@delete_memos, f) }
  end
end

get '/memos' do
  @hash = File.open('memodata.json') { |f| JSON.load(f) }
  erb :memolist
end

get '/memos/newmemo' do
  erb :addmemo
end

post '/memos' do
  id = SecureRandom.random_number(10_000)
  newhead = h(params[:newhead])
  newcomment = h(params[:newcomment])
  savedata(id, newhead, newcomment)
  erb :memolist
end

get '/memos/:id' do
  $path = params[:id]
  @show_head = loaddata('headdata')
  @show_comment = loaddata('commentdata')
  erb :showmemo
end

delete '/memos/:id' do
  deletedata($path)
  redirect to('/memos')
  erb :memolist
end

get '/memos/:id/editmemo' do
  @show_head = loaddata('headdata')
  @show_comment = loaddata('commentdata')
  erb :editmemo
end

patch '/memos/:id' do
  newhead = h(params[:edithead])
  newcomment = h(params[:editcomment])
  savedata($path, newhead, newcomment)
  @show_head = loaddata('headdata')
  @show_comment = loaddata('commentdata')
  erb :showmemo
end
