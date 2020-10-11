require 'rails_helper'

RSpec.describe "As a registered user" do
  before(:each) do
    visit '/'
    @user = User.create!(username: "eDog", email: "elah@email.com", password: "password")
    click_button("Login")
  end

  it "I can visit '/', login with my email and password" do

    expect(current_path).to eq("/login")

    fill_in :email, with: @user.email
    fill_in :password, with: @user.password

    click_button("Login")
    expect(current_path).to eq("/dashboard")
  end

  it "I cannot login with incorrect email" do
    expect(current_path).to eq("/login")

    fill_in :email, with: 'eelah@email.com'
    fill_in :password, with: @user.password

    click_button("Login")
    expect(page).to have_content("Sorry, your credentials are bad.")
    expect(current_path).to eq("/login")
  end

  it "I cannot login with incorrect password" do
    expect(current_path).to eq("/login")

    fill_in :email, with: @user.email
    fill_in :password, with: 'ppassword'

    click_button("Login")
    expect(page).to have_content("Sorry, your credentials are bad.")
    expect(current_path).to eq("/login")
  end
end
