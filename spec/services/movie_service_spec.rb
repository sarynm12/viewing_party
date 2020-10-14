require 'rails_helper'

RSpec.describe MovieService do
  it 'fetch movies by search query' do
    search1 = File.read('spec/fixtures/search_movies_1.json')
    search2 = File.read('spec/fixtures/search_movies_2.json')

    stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key=#{ENV['MOVIE_API_KEY']}&include_adult=false&language=en-US&page=1&query=Pirates").to_return(status: 200, body: search1)
    stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key=#{ENV['MOVIE_API_KEY']}&include_adult=false&language=en-US&page=2&query=Pirates").to_return(status: 200, body: search2)

    search_results = MovieService.search_movies('Pirates')

    expect(search_results).to be_an(Array)

    next_result = search_results.first

    expect(next_result).to have_key :title
    expect(next_result[:title]).to be_a(String)
    expect(next_result).to have_key :vote_average
    expect(next_result[:vote_average]).to be_a(Float)
    expect(next_result).to have_key :id
    expect(next_result[:id]).to be_a(Integer)
    expect(next_result).to have_key :overview
    expect(next_result[:overview]).to be_an(String)
  end

  it 'fetch list of top rated movies' do
    json1 = File.read('spec/fixtures/top_40_movies_1.json')
    json2 = File.read('spec/fixtures/top_40_movies_2.json')

    stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US&page=1").to_return(status: 200, body: json1)
    stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US&page=2").to_return(status: 200, body: json2)

    search_results = MovieService.get_40_movies(40)

    expect(search_results).to be_an(Array)

    next_result = search_results.first

    expect(next_result).to have_key :title
    expect(next_result[:title]).to be_a(String)
    expect(next_result).to have_key :vote_average
    expect(next_result[:vote_average]).to be_a(Float)
    expect(next_result).to have_key :id
    expect(next_result[:id]).to be_a(Integer)
    expect(next_result).to have_key :overview
    expect(next_result[:overview]).to be_an(String)
  end

  it 'fetch details for specific movie' do
    first_movie = JSON.parse(File.read('spec/fixtures/first_movie_link.json'), symbolize_names: true)
    first_movie_cast = JSON.parse(File.read('spec/fixtures/first_movie_cast.json'), symbolize_names: true)

    first_movie_reviews = JSON.parse(File.read('spec/fixtures/first_movie_reviews.json'), symbolize_names: true)
    json5 = File.read('spec/fixtures/first_movie_reviews.json')
    json1 = File.read('spec/fixtures/top_40_movies_1.json')
    json2 = File.read('spec/fixtures/top_40_movies_2.json')
    json3 = File.read('spec/fixtures/first_movie_link.json')
    json4 = File.read('spec/fixtures/first_movie_cast.json')


    stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US&page=1").to_return(status: 200, body: json1)
    stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US&page=2").to_return(status: 200, body: json2)
    stub_request(:get, "https://api.themoviedb.org/3/movie/#{first_movie[:id]}?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US").to_return(status: 200, body: json3)
    stub_request(:get, "https://api.themoviedb.org/3/movie/#{first_movie[:id]}/credits?api_key=#{ENV['MOVIE_API_KEY']}").to_return(status: 200, body: json4)
    stub_request(:get, "https://api.themoviedb.org/3/movie/#{first_movie[:id]}/reviews?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US&page=1").to_return(status: 200, body: json5)

    search_results = MovieService.get_specific_movie(first_movie[:id])

    expect(search_results).to be_a(Hash)

    expect(search_results).to have_key :title
    expect(search_results[:title]).to be_a(String)
    expect(search_results).to have_key :vote_average
    expect(search_results[:vote_average]).to be_a(Float)
    expect(search_results).to have_key :id
    expect(search_results[:id]).to be_a(Integer)
    expect(search_results).to have_key :overview
    expect(search_results[:overview]).to be_an(String)
  end

  it 'fetch list of 10 cast members for a specific movie' do
    big_cast_movie = JSON.parse(File.read('spec/fixtures/big_cast_movie.json'), symbolize_names: true)
    big_cast_json = JSON.parse(File.read('spec/fixtures/big_cast.json'), symbolize_names: true)

    json7 = File.read('spec/fixtures/first_movie_reviews.json')
    json5 = File.read('spec/fixtures/big_cast_movie.json')
    json6 = File.read('spec/fixtures/big_cast.json')
    json10 = File.read('spec/fixtures/movie_with_reviews.json')
    json6 = File.read('spec/fixtures/movie_with_reviews_credits.json')
    json9 = File.read('spec/fixtures/movie_recommendations.json')

    stub_request(:get, "https://api.themoviedb.org/3/movie/299534?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US").to_return(status: 200, body: json10)
    stub_request(:get, "https://api.themoviedb.org/3/movie/#{big_cast_movie[:id]}?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US").to_return(status: 200, body: json5)
    stub_request(:get, "https://api.themoviedb.org/3/movie/#{big_cast_movie[:id]}/credits?api_key=#{ENV['MOVIE_API_KEY']}").to_return(status: 200, body: json6)
    stub_request(:get, "https://api.themoviedb.org/3/movie/299534/reviews?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US&page=1").to_return(status: 200, body: json7)
    stub_request(:get, "https://api.themoviedb.org/3/movie/299534/reviews?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US&page=1").to_return(status: 200, body: json7)
    stub_request(:get, "https://api.themoviedb.org/3/movie/299534/credits?api_key=#{ENV['MOVIE_API_KEY']}").to_return(status: 200, body: json6)
    stub_request(:get, "https://api.themoviedb.org/3/movie/299534?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US").to_return(status: 200, body: json10)
    stub_request(:get, "https://api.themoviedb.org/3/movie/299534/recommendations?api_key=&language=en-US&page=1").to_return(status: 200, body: json9)

    search_results = MovieService.find_cast(big_cast_movie[:id])

    expect(search_results).to be_a(Hash)
    expect(search_results).to have_key :cast

    cast = search_results[:cast]

    expect(cast).to be_an(Array)

    next_result = cast.first

    expect(next_result).to have_key :character
    expect(next_result[:character]).to be_a(String)
    expect(next_result).to have_key :name
    expect(next_result[:name]).to be_a(String)
  end

  it 'fetch list of reviews for a specific movie' do
    first_movie = JSON.parse(File.read('spec/fixtures/first_movie_link.json'), symbolize_names: true)
    first_movie_reviews = JSON.parse(File.read('spec/fixtures/first_movie_reviews.json'), symbolize_names: true)

    json5 = File.read('spec/fixtures/first_movie_reviews.json')
    json1 = File.read('spec/fixtures/top_40_movies_1.json')
    json2 = File.read('spec/fixtures/top_40_movies_2.json')
    json3 = File.read('spec/fixtures/first_movie_link.json')
    json4 = File.read('spec/fixtures/first_movie_cast.json')
    json9 = File.read('spec/fixtures/movie_recommendations.json')


    stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US&page=1").to_return(status: 200, body: json1)
    stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US&page=2").to_return(status: 200, body: json2)
    stub_request(:get, "https://api.themoviedb.org/3/movie/#{first_movie[:id]}?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US").to_return(status: 200, body: json3)
    stub_request(:get, "https://api.themoviedb.org/3/movie/#{first_movie[:id]}/credits?api_key=#{ENV['MOVIE_API_KEY']}").to_return(status: 200, body: json4)
    stub_request(:get, "https://api.themoviedb.org/3/movie/#{first_movie[:id]}/reviews?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US&page=1").to_return(status: 200, body: json5)
    stub_request(:get, "https://api.themoviedb.org/3/movie/724089/recommendations?api_key=&language=en-US&page=1").to_return(status: 200, body: json9)


    search_results = MovieService.find_reviews(first_movie[:id])

    expect(search_results).to be_a(Hash)
    expect(search_results).to have_key :total_results

    total_results = search_results[:total_results]
    expect(total_results).to be_an(Integer)
  end

  it 'fetch list of recoomendations for a specific movie' do
    movie_recommendations = JSON.parse(File.read('spec/fixtures/movie_recommendations.json'), symbolize_names: true)

    json9 = File.read('spec/fixtures/movie_recommendations.json')
    json10 = File.read('spec/fixtures/movie_with_reviews.json')
    json6 = File.read('spec/fixtures/movie_with_reviews_credits.json')
    json8 = File.read('spec/fixtures/movie_with_reviews_reviews.json')

    stub_request(:get, "https://api.themoviedb.org/3/movie/299534?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US").to_return(status: 200, body: json10)
    stub_request(:get, "https://api.themoviedb.org/3/movie/299534/credits?api_key=#{ENV['MOVIE_API_KEY']}").to_return(status: 200, body: json6)
    stub_request(:get, "https://api.themoviedb.org/3/movie/299534/reviews?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US&page=1").to_return(status: 200, body: json8)
    stub_request(:get, "https://api.themoviedb.org/3/movie/299534/recommendations?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US&page=1").to_return(status: 200, body: json9)
    stub_request(:get, "https://api.themoviedb.org/3/movie/299534/recommendations?api_key=&language=en-US&page=1").to_return(status: 200, body: json9)

    search_results = MovieService.recommendations(299534, ENV['MOVIE_API_KEY'])

    expect(search_results).to be_a(Hash)
    expect(search_results).to have_key :results

    results = search_results[:results]

    next_result = results.first

    expect(results).to be_an(Array)

    expect(next_result).to have_key :id
    expect(next_result[:id]).to be_a(Integer)
    expect(next_result).to have_key :title
    expect(next_result[:title]).to be_a(String)
  end

  it 'fetch current popular movies' do
    json1 = File.read('spec/fixtures/popular_movies_1.json')
    json2 = File.read('spec/fixtures/popular_movies_2.json')

    stub_request(:get, "https://api.themoviedb.org/3/movie/popular?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US&page=1").to_return(status: 200, body: json1)
    stub_request(:get, "https://api.themoviedb.org/3/movie/popular?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US&page=2").to_return(status: 200, body: json2)

    search_results = MovieService.popular(40)

    expect(search_results).to be_an(Array)

    next_result = search_results.first

    expect(next_result).to have_key :title
    expect(next_result[:title]).to be_a(String)
    expect(next_result).to have_key :vote_average
    expect(next_result[:vote_average]).to be_a(Float)
    expect(next_result).to have_key :id
    expect(next_result[:id]).to be_a(Integer)
    expect(next_result).to have_key :overview
    expect(next_result[:overview]).to be_an(String)
  end
end
