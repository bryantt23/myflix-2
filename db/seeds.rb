# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


comedies = Category.create(name: "Comedies")

tv_shows = Category.create(name: "TV Shows")

mysteries = Category.create(name: "Mysteries")

family_guy = Video.create(title: 'Family Guy',
              description: "Family Guy is a successful comedy cartoon created by Seth McFarlane. It's hilarious!",
              small_cover_url: "family_guy.jpg",
              large_cover_url: "family_guy.jpg",
              categories: [comedies, tv_shows, mysteries])

south_park = Video.create(title: 'South Park',
              description: "South Park is created by Trey Parker and Matt Stone. It's raunchy and extremely funny.",
              small_cover_url: "south_park.jpg",
              large_cover_url: "south_park.jpg",
              categories: [comedies, tv_shows, mysteries])

futurama = Video.create(title: 'Futurama',
              description: "Step into the future as created by Matt Groening. It's a blast for the whole family.",
              small_cover_url: "futurama.jpg",
              large_cover_url: "futurama.jpg",
              categories: [comedies, tv_shows, mysteries])

monk = Video.create(title: 'Monk',
              description: "Watch this Obsessive Compulsive germophobe solve the toughest crimes while laughing hysterically.",
              small_cover_url: "monk.jpg",
              large_cover_url: "monk_large.jpg",
              categories: [comedies, tv_shows, mysteries])

luke = User.create(full_name: 'Luke Tower', email: 'luke@myflix.com', password: "password")
bob = User.create(full_name: 'Bob Smith', email: 'bob@myflix.com', password: "bob")
mike = User.create(full_name: 'Mike Watt', email: 'mike@myflix.com', password: "mike")
fred = User.create(full_name: 'Fred Smith', email: 'fred@myflix.com', password: "fred")

UserReview.create(user: luke, video: monk, rating: 5, body: 'This show is hilarious!')
UserReview.create(user: bob, video: monk, rating: 4, body: 'Great show!')
UserReview.create(user: mike, video: monk, rating: 3, body: 'It is alright.')
UserReview.create(user: fred, video: monk, rating: 2, body: 'This show is not that great!')

UserReview.create(user: luke, video: family_guy, rating: 3, body: 'Not that bad.')
UserReview.create(user: bob, video: family_guy, rating: 1, body: 'Lousy!')
UserReview.create(user: mike, video: family_guy, rating: 4, body: 'Pretty darn funny.')
UserReview.create(user: fred, video: family_guy, rating: 3, body: 'It is average.')

UserReview.create(user: luke, video: south_park, rating: 2, body: 'Meh.')
UserReview.create(user: bob, video: south_park, rating: 4, body: 'Great show!')
UserReview.create(user: mike, video: south_park, rating: 1, body: 'Bad show.')
UserReview.create(user: fred, video: south_park, rating: 3, body: 'There were a couple funny episodes')

UserReview.create(user: luke, video: futurama, rating: 4, body: 'This show is hilarious!')
UserReview.create(user: bob, video: futurama, rating: 4, body: 'Great show!')
UserReview.create(user: mike, video: futurama, rating: 1, body: 'Yucky!.')
UserReview.create(user: fred, video: futurama, rating: 2, body: 'This show is not that great!')
