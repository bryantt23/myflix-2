require 'spec_helper'

feature "user invites a friend to Myflix" do
  scenario "user logs in and invites a friend" do
    bob = Fabricate(:user, email: "bob@myflix.com")
    visit root_path
    click_link("Sign In")
    fill_in :email, with: bob.email
    fill_in :password, with: bob.password
    click_button("Sign In")
    click_link("dlabel")
    click_link("Invite a friend")
    fill_in "Friend's Name", with: "Joe Smith"
    fill_in "Friend's Email Address", with: "joe@example.com"
    fill_in "invite_message", with: "Hi Joe!  You should join MyFlix!  It's awesome!"
    click_button("Send Invitation")
    page.should have_content("You have invited")
    clear_email
  end

  scenario "user invites a friend and the friend joins" do
    bob = Fabricate(:user, email: "bob@myflix.com")
    visit root_path
    click_link("Sign In")
    fill_in :email, with: bob.email
    fill_in :password, with: bob.password
    click_button("Sign In")
    click_link("dlabel")
    click_link("Invite a friend")
    fill_in "Friend's Name", with: "Joe Smith"
    fill_in "Friend's Email Address", with: "joe@example.com"
    fill_in "invite_message", with: "Hi Joe!  You should join MyFlix!  It's awesome!"
    click_button("Send Invitation")
    page.should have_content("You have invited")
    click_link("dlabel")
    click_link("Sign Out")
    open_email("joe@example.com")
    current_email.should have_content("Hi Joe!")
    current_email.click_link("Accept this invitation")
    page.should have_content("Register")
    fill_in "Password", with: "new_password"
    fill_in "Full Name", with: "Joe Smith"
    click_button("Sign Up")
    page.should have_content("Sign in")
    fill_in :email, with: "joe@example.com"
    fill_in :password, with: "new_password"
    click_button "Sign In"
    page.should have_content("enjoy!")
    click_link "People"
    page.should have_content(bob.full_name)
    click_link("Sign Out")
    click_link("Sign In")
    fill_in :email, with: bob.email
    fill_in :password, with: bob.password
    click_button("Sign In")
    page.should have_content("enjoy!")
    click_link("People")
    page.should have_content("Joe Smith")
    clear_email
  end
end