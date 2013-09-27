require 'spec_helper'

feature "User interacts with My Queue page" do
  given(:bob) { Fabricate(:user) }
  given(:comedies) { Category.create(name: "Comedies") }

  scenario "user adds multiple videos to the queue and changes their order" do
    login(bob)
    monk = Fabricate(:video, title: 'Monk', categories: [comedies] )
    futurama = Fabricate(:video, title: 'Futurama', categories: [comedies])
    south_park = Fabricate(:video, title: 'South Park', categories: [comedies])
    Video.all.each do |video|
      video.user_reviews << Fabricate(:user_review, user_id: bob.id, video_id: video.id)
    end

    visit root_path
    page.should have_content("Comedies")


    add_video_to_queue(monk)
    page.should have_content("Monk")

    visit root_path

    add_video_to_queue(futurama)
    page.should have_content("Futurama")

    visit root_path
    add_video_to_queue(south_park)
    page.should have_content("South Park")

    change_list_order(monk, 3)
    change_list_order(futurama, 1)
    change_list_order(south_park, 2)

    click_button "Update Instant Queue"

    expect_video_in_correct_order(futurama, 1)
    expect_video_in_correct_order(south_park, 2)
    expect_video_in_correct_order(monk, 3)
  end
end

def change_list_order(video, position)
  within(:xpath, "//tr[contains(.,'#{video.title}')]") do
    fill_in "queue_items[][order_id]", with: position
  end
end

def expect_video_in_correct_order(video, position)
  expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq("#{position}")
end