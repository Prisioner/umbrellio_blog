# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# count of posts, users & ip addresses to generate
POST_COUNT = 250_000
USER_COUNT = 120
IP_ADDRESS_COUNT = 60

# generate uniq usernames
usernames = []
USER_COUNT.times { usernames << Faker::Internet.unique.user_name }

# generate uniq IP addresses
ip_addresses = []
IP_ADDRESS_COUNT.times { ip_addresses << Faker::Internet.unique.ip_v4_address }

# grant each user 1..5 ips to post with
# { username: 'Vasya', ip: ['1.1.1.1', '2.2.2.2', '3.3.3.3']}
usernames_with_ips = usernames.map { |u| { username: u, ip: ip_addresses.sample(rand(1..5)) } }

# creating posts
POST_COUNT.times do
  # peak random user
  user = usernames_with_ips.sample
  username = user[:username]
  # peak one of user IP addresses
  ip = user[:ip].sample

  body = Faker::Lorem.paragraphs(5).join('\n')
  title = Faker::Lorem.sentence

  post_handler = PostHandler.execute(
                   username: username,
                   title: title,
                   body: body,
                   ip: ip
                 )

  # rate every ~ 1 of 100 posts
  if rand(100) == 0
    post_id = post_handler.id
    post = Post.find(post_id)

    # rate post 1-50 times
    rand(1..50).times do
      rate = rand(1..5)
      RateHandler.execute({ rate: rate }, post)
    end
  end
end
