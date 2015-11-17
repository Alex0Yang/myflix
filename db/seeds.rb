# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
 def image_1
   ['/tmp/family_guy.jpg', '/tmp/futurama.jpg', '/tmp/monk.jpg', '/tmp/south_park.jpg'].sample
 end

image_2 = '/tmp/monk_large.jpg'
categories = Category.create([{ name:"Commedies" }, { name:"Dramas" } ])
category_1 = categories.first
category_2 = categories[1]

Video.create(title:"The Shawshank Redemption", description:"Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.", small_cover_url:image_1, large_cover_url:image_2, category:category_1)
Video.create(title:"The Dark Knight", description:"When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, the caped crusader must come to terms with one of the greatest psychological tests of his ability to fight injustice.", small_cover_url:image_1, large_cover_url:image_2, category:category_1)
Video.create(title:"The Godfather: Part II", description:"The early life and career of Vito Corleone in 1920s New York is portrayed while his son, Michael, expands and tightens his grip on his crime syndicate stretching from Lake Tahoe, Nevada to pre-revolution 1958 Cuba.", small_cover_url:image_1, large_cover_url:image_2, category:category_1)
Video.create(title:"The Godfather", description:"The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.", small_cover_url:image_1, large_cover_url:image_2, category:category_1)
Video.create(title:"12 Angry Men", description:"A dissenting juror in a murder trial slowly manages to convince the others that the case is not as obviously clear as it seemed in court.", small_cover_url:image_1, large_cover_url:image_2, category:category_1)
Video.create(title:"The Shawshank Redemption", description:"Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.", small_cover_url:image_1, large_cover_url:image_2, category:category_1)
Video.create(title:"The Dark Knight", description:"When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, the caped crusader must come to terms with one of the greatest psychological tests of his ability to fight injustice.", small_cover_url:image_1, large_cover_url:image_2, category:category_1)
Video.create(title:"The Godfather: Part II", description:"The early life and career of Vito Corleone in 1920s New York is portrayed while his son, Michael, expands and tightens his grip on his crime syndicate stretching from Lake Tahoe, Nevada to pre-revolution 1958 Cuba.", small_cover_url:image_1, large_cover_url:image_2, category:category_1)
Video.create(title:"The Godfather", description:"The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.", small_cover_url:image_1, large_cover_url:image_2, category:category_1)
Video.create(title:"12 Angry Men", description:"A dissenting juror in a murder trial slowly manages to convince the others that the case is not as obviously clear as it seemed in court.", small_cover_url:image_1, large_cover_url:image_2, category:category_1)
Video.create(title:"The Shawshank Redemption", description:"Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.", small_cover_url:image_1, large_cover_url:image_2, category:category_1)
Video.create(title:"The Dark Knight", description:"When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, the caped crusader must come to terms with one of the greatest psychological tests of his ability to fight injustice.", small_cover_url:image_1, large_cover_url:image_2, category:category_2)
Video.create(title:"The Godfather: Part II", description:"The early life and career of Vito Corleone in 1920s New York is portrayed while his son, Michael, expands and tightens his grip on his crime syndicate stretching from Lake Tahoe, Nevada to pre-revolution 1958 Cuba.", small_cover_url:image_1, large_cover_url:image_2, category:category_2)
Video.create(title:"The Godfather", description:"The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.", small_cover_url:image_1, large_cover_url:image_2, category:category_2)
Video.create(title:"12 Angry Men", description:"A dissenting juror in a murder trial slowly manages to convince the others that the case is not as obviously clear as it seemed in court.", small_cover_url:image_1, large_cover_url:image_2, category:category_2)
