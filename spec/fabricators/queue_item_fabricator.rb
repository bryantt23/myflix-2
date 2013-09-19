Fabricator(:queue_item) do
  user_id { Faker::Number.digit }
  video_id { Faker::Number.digit }
  order_id { Faker::Number.digit }
end