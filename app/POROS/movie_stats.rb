class MovieStats
  def self.calculate_time(movie)
    hours = movie.runtime / 60
    minutes = movie.runtime % 60
    hours > 1 ? "#{hours} hours and #{minutes} minutes" : "#{hours} hour and #{minutes} minutes"
  end
end
