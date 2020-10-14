require 'rails_helper'

RSpec.describe 'viewing party page' do
  before(:each) do
    @user = User.create!(username: "eDog", email: "elah@email.com", password: "password")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end # VCR will clean up, shorten tests

  describe 'As an authenticated user' do
    describe "When I visit the new viewing party page," do
      it "I should see a form with movie title, duration, date, time, friends, and button to create it" do
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
        hours = first_movie[:runtime]/60
        minutes = first_movie[:runtime] % 60
        @user1 = User.create!(username: "eDog2", email: "elah1@email.com", password: "password")
        @user2 = User.create!(username: "eCat2", email: "ecat1@email.com", password: "cats")
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)

        visit '/dashboard'
        fill_in :email, with: "#{@user2.email}"
        click_button 'Add Friend'
        visit "/discover"
        click_button "Discover Top 40 Movies"
        within(first(".cards")) do
          click_link
        end
        expect(current_path).to eq("/movies/#{first_movie[:id]}")
        click_button("Create viewing party")
        expect(current_path).to eq("/movies/#{first_movie[:id]}/party/new")
        # save_and_open_page
        expect(page).to have_content("Movie")
        expect(page).to have_field("Duration")
        page.find('#date_2_1i')
        expect(page).to have_content("Start time")
        expect(page).to have_content("Invite Friends:")
        expect(page).to have_content("#{@user2.username}")
        expect(page).to have_field("friend_#{@user2.id}")
        within("#friend-#{@user2.id}") do
          check "friend_#{@user2.id}"
        end
        expect(page).to have_button("Create viewing party")
        click_button("Create viewing party")
        expect(current_path).to eq("/dashboard")
        within(first(".viewing-parties")) do
          expect(page).to have_content("Movie:")
          expect(page).to have_content("On:")
          expect(page).to have_content("At:")
          expect(page).to have_content("With:")
          expect(page).to have_content("#{@user2.username}")
        end
      end
    end
  end
end
