# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Video.create(title: 'Family Guy',
              description: "Family Guy is a successful comedy cartoon created by Seth McFarlane. It's hilarious!",
              small_cover_url: "family_guy.jpg",
              large_cover_url: "family_guy.jpg")

Video.create(title: 'South Park',
              description: "South Park is created by Trey Parker and Matt Stone. It's raunchy and extremely funny.",
              small_cover_url: "south_park.jpg",
              large_cover_url: "south_park.jpg")

Video.create(title: 'Futurama',
              description: "Step into the future as created by Matt Groening. It's a blast for the whole family.",
              small_cover_url: "futurama.jpg",
              large_cover_url: "futurama.jpg")

Video.create(title: 'Monk',
              description: "Watch this Obsessive Compulsive germophobe solve the toughest crimes while laughing hysterically.",
              small_cover_url: "monk.jpg",
              large_cover_url: "monk_large.jpg")