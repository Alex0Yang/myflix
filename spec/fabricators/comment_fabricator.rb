Fabricator(:comment) do
  rate { Faker::Number.between(1, 5) }
  content { Faker::Lorem.paragraphs(1, true).first }
  user
  video
end
