require 'rails_helper'

describe MovieParty, type: :model do
  describe 'validations' do
    it {should validate_presence_of :movie_title}
    it {should validate_presence_of :duration}
    it {should validate_presence_of :date}
    it {should validate_presence_of :start_time}
  end

  describe 'relationships' do
    it {should belong_to :user}
    it {should have_many(:party_users)}
    it {should have_many(:users).through(:party_users)}
  end

  describe 'instance methods' do
    it 'can tell if a user has been invited' do
      user = User.create!(username: "Dog", email: "ela@email.com", password: "password")
      user2 = User.create!(username: "Cat", email: "ela2@email.com", password: "password")
      user3 = User.create!(username: "Bird", email: "ela3@email.com", password: "password")
      user4 = User.create!(username: "Elephant", email: "ela4@email.com", password: "password")

      Friendship.create!(user_id: user.id, friend_id: user2.id)
      Friendship.create!(user_id: user2.id, friend_id: user.id)
      Friendship.create!(user_id: user.id, friend_id: user3.id)
      Friendship.create!(user_id: user3.id, friend_id: user.id)
      Friendship.create!(user_id: user2.id, friend_id: user4.id)
      Friendship.create!(user_id: user4.id, friend_id: user2.id)

      movie_party = MovieParty.create!(movie_title: "The Dogs", duration: 129, date: "02/10/92", start_time: "8:30", user_id: user.id)
      movie_party1 = MovieParty.create!(movie_title: "The Cats", duration: 129, date: "02/10/92", start_time: "10:30", user_id: user4.id)

      PartyUser.create!(movie_party_id: movie_party.id, user_id: user2.id)
      PartyUser.create!(movie_party_id: movie_party.id, user_id: user3.id)
      PartyUser.create!(movie_party_id: movie_party1.id, user_id: user2.id)

      expect(user.been_invited?).to eq(false)
      expect(user2.been_invited?).to eq(true)
      expect(user3.find_parties.empty?).to eq(false)
    end

  end
end
