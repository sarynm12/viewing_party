require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Home page' do
  it "When a user visit's the root page, they see a welcome message" do

    visit "/"
    
    expect(page).to have_content("Let's")
    expect(page).to have_content("Make a")
    expect(page).to have_content("Party!")
  end

  it "has a description of the application" do

    description = "Explore movies and create a viewing party event for you and your friends to watch a movie together!"
    visit "/"
    expect(page).to have_content(description)
  end

  it "has a button for users to log in" do

    visit "/"

    expect(page).to have_button("Login")
  end

  it "has a button for users to register" do

    visit "/"

    expect(page).to have_button("Register")
  end
end
