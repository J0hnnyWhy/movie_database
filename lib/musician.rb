class Musician
  attr_reader(:name, :id)

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

    define_singleton_method(:all) do
    returned_musician = DB.exec("SELECT * FROM movie_musicians;")
    musicians = []
    returned_musician.each() do |musician|
      name = musician.fetch("name")
      id = musician.fetch("id").to_i()
      musicians.push(Musician.new({:name => name, :id => id}))
    end
    musicians
  end

  define_singleton_method(:find) do |id|
    result = DB.exec("SELECT * FROM movie_musicians WHERE id = #{id};")
    name = result.first().fetch("name")
    Musician.new({:name => name, :id => id})
  end


  define_method(:save) do
    result = DB.exec("INSERT INTO movie_musicians (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  define_method(:==) do |another_musician|
    self.name().==(another_musician.name()).&(self.id().==(another_musician.id()))
  end

  define_method(:update) do |attributes|
    @name = attributes.fetch(:name, @name)
    DB.exec("UPDATE movie_musicians SET name = '#{@name}' WHERE id = #{self.id()};")

    attributes.fetch(:movie_ids, []).each() do |movie_id|
      DB.exec("INSERT INTO musicians_movies (musician_id, movie_id) VALUES (#{self.id()}, #{movie_id});")
    end
  end

    define_method(:movies) do
      musician_movies = []
      results = DB.exec("SELECT movie_id FROM musicians_movies WHERE musician_id = #{self.id()};")
      results.each() do |result|
        movie_id = result.fetch("movie_id").to_i()
        movie = DB.exec("SELECT * FROM movies WHERE id = #{movie_id};")
        name = movie.first().fetch("name")
        musician_movies.push(Movie.new({:name => name, :id => movie_id}))
      end
      musician_movies
    end

  define_method(:delete) do
    DB.exec("DELETE FROM musicians_movies WHERE musician_id = #{self.id()};")
    DB.exec("DELETE FROM movie_musicians WHERE id = #{self.id()};")
  end
end
