require('spec_helper')

describe(Musician) do

  describe("#initialize") do
    it("is initialized with a name") do
      musician = Musician.new({:name => "Prince", :id => nil})
      expect(musician).to(be_an_instance_of(Musician))
    end

    it("can be initialized with its database ID") do
      musician = Musician.new({:name => "Prince", :id => 1})
      expect(musician).to(be_an_instance_of(Musician))
     end
   end

     describe(".all") do
    it("starts off with no movies") do
      expect(Musician.all()).to(eq([]))
    end
  end

    describe(".find") do
    it("returns a musician by its ID number") do
      test_musician = Musician.new({:name => "Prince", :id => nil})
      test_musician.save()
      test_musician2 = Musician.new({:name => "George Benson", :id => nil})
      test_musician2.save()
      expect(Musician.find(test_musician2.id())).to(eq(test_musician2))
    end
  end

  describe("#==") do
    it("is the same musician if it has the same name and id") do
      musician = Musician.new({:name => "Prince", :id => nil})
      musician2 = Musician.new({:name => "Prince", :id => nil})
      expect(musician).to(eq(musician2))
    end
  end

  describe("#update") do
    it("lets you add a movie to an musician") do
      movie = Movie.new({:name => "Oceans Eleven", :id => nil})
      movie.save()
      musicians = Musician.new({:name => "Prince", :id => nil})
      musicians.save()
      musicians.update({:movie_ids => [movie.id()]})
      expect(musicians.movies()).to(eq([movie]))
    end
  end

  describe("#movies") do
    it("returns all of the movies a particular musician has been in") do
        movie = Movie.new(:name => "Purple Rain", :id => nil)
        movie.save()
        movie2 = Movie.new(:name => "Yellow Rain", :id => nil)
        movie2.save()
        musician = Musician.new(:name => "Prince", :id => nil)
        musician.save()
        musician.update(:movie_ids => [movie.id()])
        musician.update(:movie_ids => [movie2.id()])
        expect(musician.movies()).to(eq([movie, movie2]))
    end
  end

  describe("#delete") do
    it("lets you delete an musician from the database") do
     musician = Musician.new({:name => "Prince", :id => nil})
     musician.save()
     musician2 = Musician.new({:name => "George Benson", :id => nil})
      musician2.save()
      musician.delete()
      expect(Musician.all()).to(eq([musician2]))
    end
  end
end
