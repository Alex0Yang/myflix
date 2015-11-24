Fabricator(:video) do
  title { Faker::Book.title }
  description { Faker::Lorem.paragraph(6) }
  category
end
