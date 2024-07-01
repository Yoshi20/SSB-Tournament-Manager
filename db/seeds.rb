# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

yomi = User.find_by_email('jascha_haldemann@hotmail.com')
if yomi.present?
  yomi.update(is_admin: true, is_super_admin: true)
end

hdmp = User.find_by_email('wanja_haldemann@hotmail.ch')
if hdmp.present?
  hdmp.update(is_admin: true, is_super_admin: true)
end


# Surveys:
Survey.find_or_create_by(
  question: "I'm thinking about implementing a simple shop where any user can offer their products or services like coaching, artwork, mods, etc.
  Would you use it?",
  option1: "Yes, as a seller (and buyer)",
  option2: "Yes, as a buyer",
  option3: "No",
  ends_at: DateTime.parse("16.07.2024"),
)
