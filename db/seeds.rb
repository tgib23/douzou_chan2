# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

99.times do |n|
  email = "douzou-chan-#{n+1}@test.org"
  provider = n%2 == 0 ? "facebook" : "twitter"
  uid = n
  password = "foobar"
  User.create!(email: email,
               provider: provider,
               uid: uid,
               password:              password,
               password_confirmation: password)
end

users = User.order(:created_at).take(6)
50.times do |n|
  country = n % 2 == 0 ? "日本" : "US"
  province = n % 2 == 0 ? "鹿児島県" : "CA"
  city = n % 2 == 0 ? "指宿市" : "Los Angeles"
  address = n % 2 == 0 ? "日本 鹿児島県指宿市指宿1-1-1" : "Santa Monica, Los Angeles, CA, US"
  author = n % 2 == 0 ? "運慶" : "Michaelangelo"
  name = n % 2 == 0 ? "金剛力士像" : "Davide"
  year = 1500
  link = "http://www.yahoo.co.jp"
  users.each { |user| user.posts.create!(coordinate: "35.#{n}#{n}#{n},139.#{n}#{n}#{n}55",
                                         country: country,
                                         province: province,
                                         city: city,
                                         address: address,
                                         author: author,
                                         name: name,
                                         year: year,
                                         link: link
  ) }
end
