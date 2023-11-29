# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'

Question.destroy_all

# 3.times do
#     Question.create(
#         question: Faker::Lorem.sentence(word_count: 4),
#         answer: Faker::Lorem.sentence(word_count: 6),
#     )
# end

User.destroy_all
adminUser = User.create(username: "admin", password: "Password12345")
puts 'Created Admin user', adminUser