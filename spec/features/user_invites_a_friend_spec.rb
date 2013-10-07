require 'spec_helper'

feature "user invites a friend to Myflix" do
  scenario "user logs in and invites a friend" do
    bob = Fabricate(:user, email: "bob@myflix.com")
    visit root_path
    click_link("Sign In")
    fill_in :email, with: bob.email
    fill_in :password, with: bob.password
    click_button("Sign In")
    visit new_invite_path
    fill_in "Friend's Name", with: "Joe Smith"
    fill_in "Friend's Email Address", with: "joe@example.com"
    fill_in "invite_message", with: "Hi Joe!  You should join MyFlix!  It's awesome!"
    click_button("Send Invitation")
  end
end