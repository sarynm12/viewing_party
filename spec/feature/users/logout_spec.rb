require 'rails_helper'

RSpec.describe "As a registered user" do
  before(:each) do
    visit '/'
    @user = User.create!(username: "eDog", email: "elah@email.com", password: "password")
    click_button("Login")
    expect(current_path).to eq("/login")
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_button("Login")
  end

  it "When I am logged in, I see a logout button" do
    expect(current_path).to eq("/dashboard")

    expect(page).to have_button("Logout")
  end

  it "I am logged out when I click the 'Logout' button" do
    expect(current_path).to eq("/dashboard")
    
    click_button("Logout")
    expect(current_path).to eq("/")
    expect(page).to have_content("You have been logged out")
  end
end
