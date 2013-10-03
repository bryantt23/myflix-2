require "spec_helper"

feature "Registration" do

  scenario "user registers and receives email confirmation" do
    bob = Fabricate(:user)
    visit register_path
    fill_in "Email Address", with: bob.email
    fill_in "Password", with: bob.password
    fill_in "Full Name", with: bob.full_name
    click_button "Sign Up"

    page.should have_content("Welcome to Myflix, #{bob.full_name}!")
  end
end