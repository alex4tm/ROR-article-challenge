# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Article.destroy_all
puts 'Creating 2 articles...'
Article.create!({
                  title: "Ruby on Rails in 2019",
                  source_link: "https://medium.com/swlh/ruby-on-rails-in-2019-ae3ec463b8bb"
                })
Article.create!({
                  title: "5 New Ruby on Rails How-To Articles to Read on Medium",
                  source_link: "https://blog.planetargon.com/entries/5-new-ruby-on-rails-how-to-articles-to-read-on-medium"
                })
puts 'Done!'
