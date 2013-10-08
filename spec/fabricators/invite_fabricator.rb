Fabricator(:invite) do
  invited_name { Faker::Name.name }
  invited_email { Faker::Internet.email }
  message { Faker::Lorem.paragraphs(2) }
end