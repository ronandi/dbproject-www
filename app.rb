require 'sinatra'
require 'json'
require 'sequel'
require 'will_paginate'
require 'will_paginate/sequel'
require 'will_paginate-bootstrap'

user = ENV['cs336user'] || "Your user here"
pass = ENV['cs336pass'] || "Your pass here"
DB = Sequel.connect("mysql2://#{user}:#{pass}@cs336-24.cs.rutgers.edu/project").extension(:pagination)

beers = DB[:beers]
drinkers = DB[:drinkers]
favorites = DB[:favorite]

get '/' do
  erb :index
end

get '/beers' do
  @beers = beers.all
  erb :beers
end

get '/drinkers' do
  page_num = params[:page] || 1
  @drinkers = drinkers.paginate(page_num.to_i, 100)
  erb :drinkers
end

get '/favorites' do
  page_num = params[:page] || 1
  @favorites = DB.fetch('select name, beer from drinkers join favorite where id = drinker_id').paginate(page_num.to_i, 100)
  erb :favorites
end

get '/likes' do
  page_num = params[:page] || 1
  @likes = DB.fetch('select name, beer from drinkers join likes where id = drinker_id').paginate(page_num.to_i, 100)
  erb :likes
end

get '/trend1' do
  erb :trend1
end

get '/trend1json' do
  DB.fetch('select beer, count(*) as frequency from firstbeer group by beer order by count(*) desc limit 10').all.to_json
end

