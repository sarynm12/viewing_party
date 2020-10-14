class MoviesFacade
  def self.search_movies(keyword)
    results = MovieService.search_movies(keyword)
    results.map do |data|
      CreateMovie.new(data)
    end
  end

  def self.get_40_movies(movie_count)
    movie_results = MovieService.get_40_movies(movie_count)
    movie_results.map do |data|
      CreateMovie.new(data)
    end
  end

  # change above method, it's redundant to have 40, then movie count in argument
  def self.get_specific_movie(id)
    movie = MovieService.get_specific_movie(id)
    CreateMovie.new(movie)
  end

  def self.find_cast(id)
    result = MovieService.find_cast(id)[:cast]
    result.map do |member|
      CreateActor.new(member)
    end
  end

  def self.find_reviews(id)
    result = MovieService.find_reviews(id)
    return [] if result[:total_results] == []

    result[:results].map do |review|
      CreateReview.new(review)
    end
  end

  def self.find_recommendations(id, api_key)
    result = MovieService.recommendations(id, api_key)
    recommended = result[:results].map do |movie|
      CreateRecommendation.new(movie)
    end
    recommended[0..4]
  end

  def self.get_current_popular(movie_count)
    movie_results = MovieService.popular(movie_count)
    movie_results.map do |data|
      CreateMovie.new(data)
    end
  end
end
