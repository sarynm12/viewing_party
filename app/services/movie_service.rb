class MovieService
  def self.movie_db
    'https://api.themoviedb.org'
  end

  def self.language_and_country
    '&language=en-US'
  end

  def self.page_and_adult
    '&page=1&include_adult=false'
  end

  def self.suffix
    '/3/search/movie?api_key='
  end

  def self.search_movies(keyword)
    page = 1
    movie_results = []
    until page == 2
      conn = Faraday.new(url: movie_db)
      response = conn.get("#{suffix}#{ENV['MOVIE_API_KEY']}#{language_and_country}&query=#{keyword}#{page_and_adult}")
      json = JSON.parse(response.body, symbolize_names: true)
      movie_results << json[:results]
      page += 1
    end
    movie_results.flatten
  end
  # API calls and parsing the response, the only two things that should live in service
  # can pull out Faraday call
  # can put the longer lines into a block to make it more readable, could possibly include it into connection method
  def self.get_40_movies(movie_count)
    page = 1
    movie_results = []
    until movie_results.length >= movie_count
      conn = Faraday.new(url: movie_db)
      response = conn.get("/3/movie/top_rated?api_key=#{ENV['MOVIE_API_KEY']}#{language_and_country}&page=#{page}")
      json = JSON.parse(response.body, symbolize_names: true)
      json[:results].each { |f| movie_results << f }
      page += 1
    end
    movie_results
  end

  def self.get_specific_movie(id)
    conn = Faraday.new(url: movie_db)
    response = conn.get("/3/movie/#{id}?api_key=#{ENV['MOVIE_API_KEY']}#{language_and_country}")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.find_cast(id)
    conn = Faraday.new(url: movie_db)
    response = conn.get("/3/movie/#{id}/credits?api_key=#{ENV['MOVIE_API_KEY']}")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.find_reviews(id)
    conn = Faraday.new(url: movie_db)
    response = conn.get("/3/movie/#{id}/reviews?api_key=#{ENV['MOVIE_API_KEY']}#{language_and_country}&page=1")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.recommendations(id, api_key)
    conn = Faraday.new(url: 'https://api.themoviedb.org')
    response = conn.get("/3/movie/#{id}/recommendations?api_key=#{api_key}&language=en-US&page=1")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.popular(movie_count)
    page = 1
    movie_results = []
    until movie_results.length >= movie_count
      conn = Faraday.new(url: movie_db)
      response = conn.get("/3/movie/popular?api_key=#{ENV['MOVIE_API_KEY']}#{language_and_country}&page=#{page}")
      json = JSON.parse(response.body, symbolize_names: true)
      json[:results].each { |f| movie_results << f }
      page += 1
    end
    movie_results
  end
end
