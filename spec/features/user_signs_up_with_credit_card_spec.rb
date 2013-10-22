require 'spec_helper'

feature "user signs up with credit card", { js: true, vcr: true } do
  scenario "user signs up with all valid information" do
    enter_good_user_info
    enter_card_info('4242424242424242')
    click_on "Sign Up"
    page.should have_content("Sign in")
  end

  scenario "user signs up with invalid user information" do
    visit register_path
    fill_in "Email", with: "bob@myflix.net"
    fill_in "Full Name", with: "Bob Smith"
    enter_card_info('4242424242424242')
    click_on "Sign Up"
    page.should have_content("Password can't be blank")
  end

  scenario "user signs up with invalid card number" do
    enter_good_user_info
    enter_card_info('1234234234')
    click_on "Sign Up"
    page.should have_content("Your card number is incorrect.")
  end

  scenario "user signs up with declined card" do
    enter_good_user_info
    enter_card_info('4000000000000002')
    click_on "Sign Up"
    page.should have_content("Your card was declined.")
  end
end

def enter_good_user_info
  visit register_path
  fill_in "Email", with: "bob@myflix.com"
  fill_in "Password", with: "password"
  fill_in "Full Name", with: "Bob Smith"
end

def enter_card_info(number)
  fill_in "Credit Card Number", with: number
    fill_in "Security Code", with: "123"
    select "10 - October", from: 'date_month'
    select "2016", from: 'date_year'
end