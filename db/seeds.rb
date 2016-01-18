# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(full_name: "Alex Yang", email: "yang@yang.com", password: "password")
2.times.each { Fabricate(:user) }

3.times.each { Fabricate(:category) }

50.times.each { Fabricate(:video, category: Category.all.sample) }
200.times.each { Fabricate(:comment, user: User.all.sample, video: Video.all.sample) }
Video.all.each { |video| Fabricate(:queue_item, user: User.all.sample, video: video) }

