Fabricator(:video) do
  title { Faker::Book.title }
  description { Faker::Lorem.paragraph(6) }
  category
  small_cover_url { ['/tmp/family_guy.jpg', '/tmp/futurama.jpg', '/tmp/monk.jpg', '/tmp/south_park.jpg'].sample }
  large_cover_url { '/tmp/monk_large.jpg' }
end
