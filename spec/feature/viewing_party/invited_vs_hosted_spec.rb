require 'rails_helper'

RSpec.describe 'Dashboard page' do
  before(:each) do
    @user = User.create!(username: "eDog", email: "elah@email.com", password: "password")
    @user2 = User.create!(username: "eCat", email: "elah2@email.com", password: "password")
    @user3 = User.create!(username: "eBird", email: "elah3@email.com", password: "password")
    @user4 = User.create!(username: "eElephant", email: "elah4@email.com", password: "password")

    Friendship.create!(user_id: @user.id, friend_id: @user2.id)
    Friendship.create!(user_id: @user2.id, friend_id: @user.id)
    Friendship.create!(user_id: @user.id, friend_id: @user3.id)
    Friendship.create!(user_id: @user3.id, friend_id: @user.id)
    Friendship.create!(user_id: @user2.id, friend_id: @user4.id)
    Friendship.create!(user_id: @user4.id, friend_id: @user2.id)

    @movie_party = MovieParty.create!(movie_title: "The Dogs", duration: 129, date: "02/10/92", start_time: "8:30", user_id: @user.id)
    @movie_party1 = MovieParty.create!(movie_title: "The Cats", duration: 129, date: "02/10/92", start_time: "10:30", user_id: @user4.id)

    PartyUser.create!(movie_party_id: @movie_party.id, user_id: @user2.id)
    PartyUser.create!(movie_party_id: @movie_party.id, user_id: @user3.id)
    PartyUser.create!(movie_party_id: @movie_party1.id, user_id: @user2.id)
  end

  describe 'As an authenticated user' do
    describe "If I've been invited to a movie party and visit my dashboard" do
      it "I should see that I've been invited, as well as the movie title, date, start time and with who" do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user2)
        visit '/dashboard'

        within(first(".invited-parties-#{@movie_party.id}")) do
          expect(page).to have_content("Movie: #{@movie_party.movie_title}")
          expect(page).to have_content("On: #{@movie_party.date}")
          expect(page).to have_content("At: #{@movie_party.start_time}")
          expect(page).to have_content("With:")
          expect(page).to have_content("#{@user3.username}")
          expect(page).to have_content("Hosted by: #{@user.username}")
        end
      end
    end
    describe "If I've been invited to multiple movie parties and visit my dashboard" do
      it "I should see that I've been invited, as well as the movie title, date, start time and with who" do

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user2)
        visit '/dashboard'

        within(".invited-parties-#{@movie_party1.id}") do
          expect(page).to have_content("Movie: #{@movie_party1.movie_title}")
          expect(page).to have_content("On: #{@movie_party1.date}")
          expect(page).to have_content("At: #{@movie_party1.start_time}")
          expect(page).to have_content("With:")
          expect(page).to have_content("#{@user4.username}")
          expect(page).to have_content("Hosted by: #{@user4.username}")
        end
      end
    end
  end
end
