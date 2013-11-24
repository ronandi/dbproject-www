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

get '/about' do
  erb :about
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

get '/firstbeers' do
  page_num = params[:page] || 1
  @firstbeers = DB.fetch('select name, beer from drinkers join firstbeer where id = drinker_id').paginate(page_num.to_i, 100)
  erb :firstbeers
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

get '/trend2' do
  erb :trend2
end

get '/trend3' do
  erb :trend3
end

get '/trend1json' do
  DB.fetch('select beer, count(*) as frequency from firstbeer group by beer order by count(*) desc limit 10').all.to_json
end

get '/trend1graph2' do
  DB.fetch('select `type`, count(*) as frequency from firstbeer join beers on firstbeer.beer = beers.name group by type').all.to_json
end

get '/trend1graph3' do
  DB.fetch('select type, count(*) as frequency from favorite join beers on beer = name group by type').all.to_json
end

get '/trend1graph4' do
  query = 'select age, gender, avg(ibu) as ibu from favorite join beers on beer = name join drinkers on drinker_id = id group by age, gender order by gender desc, age asc'
  DB.fetch(query).all.to_json
end

get '/trend3data' do
  query = 'select beers.abv as favorite_abv, avg(b1.abv) as liked_abv_average from favorite join beers on beer = name join drinkers on drinker_id = id
  join likes on likes.drinker_id = id join beers b1 on likes.beer = b1.name
  group by favorite_abv'
  DB.fetch(query).all.to_json
end

get '/trend2graph1' do
  DB.fetch('(select "0-20" as iburange, count(*) as frequency from  firstbeer join beers on beer = name join drinkers on drinker_id = id
           where age >= 22 and age <= 27 and ibu <= 20) union
           (select "20+" as iburange, count(*) as frequency from firstbeer join beers on beer = name join drinkers on drinker_id = id
            where age >= 22 and age <= 27 and ibu > 20)').all.to_json
end
