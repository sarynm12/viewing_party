require 'rails_helper'

RSpec.describe 'movie show page' do
  before(:each) do
    @user = User.create!(username: "eDog", email: "elah@email.com", password: "password")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

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


          stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US&page=1").to_return(status: 200, body: json1)
          stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US&page=2").to_return(status: 200, body: json2)
          stub_request(:get, "https://api.themoviedb.org/3/movie/#{first_movie[:id]}?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US").to_return(status: 200, body: json3)
          stub_request(:get, "https://api.themoviedb.org/3/movie/#{first_movie[:id]}/credits?api_key=#{ENV['MOVIE_API_KEY']}").to_return(status: 200, body: json4)
          stub_request(:get, "https://api.themoviedb.org/3/movie/#{first_movie[:id]}/reviews?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US&page=1").to_return(status: 200, body: json5)

          first_movie_cast_list = first_movie_cast[:cast].map{ |per| per[:name]}[0...9]

          hours = first_movie[:runtime]/60
          minutes = first_movie[:runtime] % 60

          visit "/discover"
          click_button "Discover Top 40 Movies"

          within(first(".movie")) do
            click_link
          end

          expect(current_path).to eq("/movies/#{first_movie[:id]}")
          expect(page).to have_content("#{first_movie[:title]}")
          expect(page).to have_content("Vote average: #{first_movie[:vote_average]}")
          expect(page).to have_content("Run time: #{hours} hour and #{minutes} minutes")
          expect(page).to have_content("Genres: #{first_movie[:genres][0][:name]}")
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


          stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US&page=1").to_return(status: 200, body: json1)
          stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US&page=2").to_return(status: 200, body: json2)
          stub_request(:get, "https://api.themoviedb.org/3/movie/#{first_movie[:id]}?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US").to_return(status: 200, body: json3)
          stub_request(:get, "https://api.themoviedb.org/3/movie/#{first_movie[:id]}/credits?api_key=#{ENV['MOVIE_API_KEY']}").to_return(status: 200, body: json4)

          stub_request(:get, "https://api.themoviedb.org/3/movie/#{first_movie[:id]}/reviews?api_key=#{ENV['MOVIE_API_KEY']}&language=en-US&page=1").to_return(status: 200, body: json5)

          visit "/discover"
          click_button "Discover Top 40 Movies"

          within(first(".movie")) do
            click_link
          end

          expect(page).to have_content("Reviews: #{first_movie_reviews[:total_results]}")
          expect(page).to have_button("Create viewing party")
        end
      end
    end
  end
end
