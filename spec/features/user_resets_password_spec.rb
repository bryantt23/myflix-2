require 'spec_helper'

feature "user resets password" do

  scenario "user logs in and navigates to forgot password page" do
    bob = Fabricate(:user, email: "bob@myflix.com", password: "old_password")
    visit root_path
    click_link("Sign In")
    click_link("Forgot Password?")
    page.should have_content("reset your password")
    fill_in :email, with: bob.email
    click_button("Send Email")
    open_email("bob@myflix.com")
    current_email.click_link("Reset My Password")
    page.should have_button("Reset Password")
    fill_in :password, with: "new_password"
    click_button("Reset Password")
    page.should have_content("Sign in")
    fill_in :email, with: bob.email
    fill_in :password, with: "new_password"
    click_button("Sign In")
    page.should have_content("enjoy!")
  end
end