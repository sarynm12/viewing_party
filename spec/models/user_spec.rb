require 'rails_helper'

describe User, type: :model do
  describe 'validations' do
    it {should validate_presence_of :username}
    it {should validate_uniqueness_of :username}
    it {should validate_presence_of :email}
    it {should validate_uniqueness_of :email}
    it {should validate_presence_of :password}
  end

  describe 'relationships' do
    it {should have_many :friendships}
    it {should have_many(:friends).through(:friendships)}
    it {should have_many :movie_parties}
  end

  it "should show if a user has been invited or not" do

    attr = { username: 'las',
      email: 'las@email.com',
      password: 'eng'
    }

    attr2 = { username: 'las2',
      email: 'las2@email.com',
      password: 'eng'
    }

    user = User.create!(attr)
    user2 = User.create!(attr2)

    movie_party = MovieParty.create!(movie_title: "The Dogs", duration: 129, date: "02/10/92", start_time: "8:30", user_id: user.id)

    PartyUser.create!(movie_party_id: movie_party.id, user_id: user2.id)

    expect(user).to be_a(User)
    expect(user.been_invited?).to eq(false)
    expect(user2.find_parties[0].movie_title).to eq("The Dogs")
  end
end
