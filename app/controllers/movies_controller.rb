class MoviesController < ApplicationController
  before_action :require_user
  def index
    @results = if params[:search]
                 MoviesFacade.search_movies(params[:search])
               elsif params[:popular]
                 MoviesFacade.get_current_popular(40)
               else
                 MoviesFacade.get_40_movies(40)
               end
  end

  def show
    @movie = MoviesFacade.get_specific_movie(params[:id].to_i)
    @runtime = MovieStats.calculate_time(@movie)
    cast = MoviesFacade.find_cast(params[:id].to_i)
    @cast = if cast.length >= 10
              MoviesFacade.find_cast(params[:id].to_i)[0..9]
            else
              MoviesFacade.find_cast(params[:id].to_i)
            end
    @recommendations = MoviesFacade.find_recommendations(params[:id].to_i, ENV['API_MOVIE_KEY'])
    @reviews = MoviesFacade.find_reviews(params[:id].to_i)
  end
end
