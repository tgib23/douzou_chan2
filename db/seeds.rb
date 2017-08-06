# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(email: "anonymous-user@railstutorial.org",
             provider: "douzou-chan",
             uid: "1",
             nickname: "anonymous user",
             password:              "foobar",
             password_confirmation: "foobar",
             first_login: 0,
             admin: false)

