require 'spec_helper'

feature "My Queue page" do
  given(:bob) { User.create(email: 'bob@stuff.com', password: 'password', full_name: 'Bob Smith') }

  scenario "logging in with valid credentials" do
    login(bob)
    page.should have_content("enjoy")
  end

  scenario "logging in with invalid credentials" do
    visit "/login"
    fill_in :email, with: bob.email
    fill_in :password, with: "passwooord"
    click_button "Sign In"
    page.should have_content("Sorry, something's wrong with your email or password.")
  end

  scenario "logging in with locked account" do
    joe = Fabricate(:user, locked: true)
    login(joe)
    page.should have_content("Your account has been locked.")
  end
end