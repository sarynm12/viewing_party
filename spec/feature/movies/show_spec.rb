require 'rails_helper'

RSpec.describe 'movie show page' do
  before(:each) do
    @user = User.create!(username: "eDog", email: "elah@email.com", password: "password")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end
  # test for gibberish typed into search parameters, or '1234', or '!#$'
  # test for how many words one can search for, 1 word vs many
  describe 'As an authenticated user' do
    describe "When I visit the movies detail page," do
      describe "I should see a button 'create a viewing party'" do
        it "and if I click this button it takes me to a new event page" do
          first_movie = JSON.parse(File.read('spec/fixtures/first_movie_link.json'), symbolize_names: true)
          first_movie_cast = JSON.parse(File.read('spec/fixtures/first_movie_cast.json'), symbolize_names: true)

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


          first_movie_cast_list = first_movie_cast[:cast].map{ |per| per[:name]}[0...9]

          hours = first_movie[:runtime]/60
          minutes = first_movie[:runtime] % 60

          visit "/discover"
          click_button "Discover Top 40 Movies"

          within(first(".cards")) do
            click_link
          end

          expect(current_path).to eq("/movies/#{first_movie[:id]}")
          expect(page).to have_content("#{first_movie[:title]}")
          expect(page).to have_content("Vote average: #{first_movie[:vote_average]}")
          expect(page).to have_content("Run time: #{hours} hour and #{minutes} minutes")
          expect(page).to have_content("Genres:")
          expect(page).to have_content("#{first_movie[:genres][0][:name]}")
          expect(page).to have_content("Overview: #{first_movie[:overview]}")
          first_movie_cast_list.each{ |per| expect(page).to have_content(per)}
        end
        it "and I should see the count of total reviews as well as each author's name and info" do
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

          visit "/discover"
          click_button "Discover Top 40 Movies"
          # save_and_open_page
          within(first(".cards")) do
            click_link
          end

          expect(page).to have_content("Reviews: #{first_movie_reviews[:total_results]}")
          expect(page).to have_button("Create viewing party")
        end
      end
    end
  end

  it "I can see only 10 members of the cast, when the cast is more than 10 people" do
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



    big_cast = big_cast_json[:cast].map{ |per| per[:name]}[0...9]
    visit("/movies/#{big_cast_movie[:id]}")

    big_cast.each{ |per| expect(page).to have_content(per)}
  end

  it "if a movie has reviews, I can see them" do
    # first_movie = JSON.parse(File.read('spec/fixtures/first_movie_link.json'), symbolize_names: true)
    first_movie_reviews = JSON.parse(File.read('spec/fixtures/movie_with_reviews_reviews.json'), symbolize_names: true)
    movie_credits = JSON.parse(File.read('spec/fixtures/movie_with_reviews_credits.json'), symbolize_names: true)

    json6 = File.read('spec/fixtures/movie_with_reviews_credits.json')
    json7 = File.read('spec/fixtures/movie_with_reviews.json')
    json8 = File.read('spec/fixtures/movie_with_reviews_reviews.json')
    json9 = File.read('spec/fixtures/movie_recommendations.json')

    stub_request(:get, "https://api.themoviedb.org/3/movie/299534/credits?api_key=#{ENV['MOVIE_API_KEY']}").to_return(status: 200, body: json6)
    stub_request(:get, "https://api.themoviedb.org/3/movie/299534/credits?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US").to_return(status: 200, body: json6)
    stub_request(:get, "https://api.themoviedb.org/3/movie/299534?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US").to_return(status: 200, body: json7)
    stub_request(:get, "https://api.themoviedb.org/3/movie/299534/reviews?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US&page=1").to_return(status: 200, body: json8)
    stub_request(:get, "https://api.themoviedb.org/3/movie/299534/recommendations?api_key=&language=en-US&page=1").to_return(status: 200, body: json9)

    visit("/movies/299534")

    expect(page).to have_content("Reviews: #{first_movie_reviews[:results].length}")
    expect(page).to have_button("Create viewing party")
  end

  it 'displays movie recommendations' do
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

    visit("/movies/299534")

    expect(page).to have_content("Recommendations")
    expect(page).to have_content("#{movie_recommendations[:results][0][:title]}")
  end
end
