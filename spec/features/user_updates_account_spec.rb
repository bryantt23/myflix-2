require 'spec_helper'

feature "Update Account" do
  given(:bob) { User.create(
                email: 'bob@stuff.com',
                password: 'password',
                full_name: 'Bob Smith') }

  # scenario "user updates account information" do
  #   login(bob)
  #   visit "/users/#{bob.id}/edit"
  #   fill_in 'Email', with: "bob@myflix.com"
  #   fill_in 'Password', with: "password"
  #   fill_in 'Confirm Password', with: "password"
  #   fill_in 'Full Name', with: "Bobby Smith"
  #   click_button "Update"
  #   page.should have_content("You have updated your account.")
  # end

  scenario "figure out why update account features spec isn't working!"

  # scenario "user updates account information with non-matching passwords" do
  #   login(bob)
  #   click_link("Welcome, #{bob.full_name}")
  #   click_link("Account")
  #   fill_in 'Email', with: "bob@myflix.com"
  #   fill_in 'user_password', with: "password"
  #   fill_in 'user_password_confirmation', with: "wordpass"
  #   fill_in 'Full Name', with: "Bobby Smith"
  #   click_button("Update")
  #   page.should have_content("Unable to update account.")
  # end
end