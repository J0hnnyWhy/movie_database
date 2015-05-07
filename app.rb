require('sinatra')
require('sinatra/reloader')
also_reload('liv/**/*.rb')
require('./lib/actor')
require('./lib/movie')
require('./lib/musician')
require('pg')

DB = PG.connect({:dbname => "movie_database"})

get("/") do
  @actors = Actor.all()
  @movies = Movie.all()
  @musicians = Musician.all()
  erb(:index)
end

get("/actors") do
  @actors = Actor.all()
  erb(:actors)
end

get("/movies") do
  @movies = Movie.all()
  erb(:movies)
end

get("/musicians") do
  @musicians = Musician.all()
  erb(:musicians)
end

post("/actors") do
  name = params.fetch("name")
  actor = Actor.new({:name => name, :id => nil})
  actor.save()
  @actors = Actor.all()
  erb(:actors)
end

post("/movies") do
  name = params.fetch("name")
  movie = Movie.new({:name => name, :id => nil})
  movie.save()
  @movies = Movie.all()
  erb(:movies)
end

post("/musicians") do
  name = params.fetch("name")
  musician = Musician.new({:name => name, :id => nil})
  musician.save()
  @musicians = Musician.all()
  erb(:musicians)
end

get("/actors/:id") do
  @actor = Actor.find(params.fetch("id").to_i())
  @movies = Movie.all()
  erb(:actor_info)
end

get("/movies/:id") do
  @movie = Movie.find(params.fetch("id").to_i())
  @actors = Actor.all()
  @musicians = Musician.all()
  erb(:movie_info)
end

get("/musicians/:id") do
  @musicians = Musician.find(params.fetch("id").to_i())
  @movies = Movie.all()
  erb(:musician_info)
end

patch("/actors/:id") do
  actor_id = params.fetch("id").to_i()
  @actor = Actor.find(actor_id)
  movie_ids = params.fetch("movie_ids")
  @actor.update({:movie_ids => movie_ids})
  @movies = Movie.all()
  erb(:actor_info)
end

patch("/movies/:id") do
  movie_id = params.fetch("id").to_i()
  @movie = Movie.find(movie_id)
  actor_ids = params.fetch("actor_ids")
  @movie.update({:actor_ids => actor_ids})
  @actors = Actor.all()
  musician_ids = params.fetch("musician_ids")
  @movie.update({:musician_ids => musician_ids})
  @musicians = Musician.all()
  erb(:movie_info)
end

patch("/musicians/:id") do
  musician_id = params.fetch("id").to_i()
  @musicians = Musician.find(musician_id)
  movie_ids = params.fetch("movie_ids")
  @musicians.update({:movie_ids => movie_ids})
  @movies = Movie.all()
  erb(:musician_info)
end
