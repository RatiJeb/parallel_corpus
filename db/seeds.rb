# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.create!(
  email: 'babdusi+pc@gmail.com',
  password: '13572468',
  password_confirmation: '13572468',
  role: :superadmin
)

lewis_carroll = Author.create!(
  name_en: 'Lewis Carroll',
  name_ka: 'ლუის კეროლი'
)
mark_twain = Author.create!(
  name_en: 'Mark Twain',
  name_ka: 'მარკ ტვენი'
)

fiction = Field.create!(
  name_en: 'Fiction',
  name_ka: 'მხატვრული ლიტერატურა'
)
mathematics = Field.create!(
  name_en: 'Mathematics',
  name_ka: 'მათემატიკა'
)

adventure = Genre.create!(
  name_en: 'Adventure',
  name_ka: 'სათავგადასავლო'
)
scientific = Genre.create!(
  name_en: 'Scientific',
  name_ka: 'სამეცნიერო'
)

novel = Type.create!(
  name_en: 'Novel',
  name_ka: 'რომანი'
)
book = Type.create!(
  name_en: 'Book',
  name_ka: 'წიგნი'
)

macmillan = Publishing.create!(
  name_en: 'Macmillan',
  name_ka: 'მაკმილანი'
)
apc = Publishing.create!(
  name_en: 'American Publishing Company',
  name_ka: 'ამერიკული საგამომცემლო კომპანია'
)

natia_chubinidze = Translator.create!(
  name_en: 'Natia Chubinidze',
  name_ka: 'ნათია ჩუბინიძე'
)
giorgi_gokieli = Translator.create!(
  name_en: 'Giorgi Gokieli',
  name_ka: 'გიორგი გოკიელი'
)

subcorpus_1 = Supergroup.create!(
  name_en: 'Subcorpus 1',
  name_ka: 'ქვეკორპუსი 1',
  status: :active
)

alice = Group.create!(
  name_en: 'Alice',
  name_ka: 'ელისი',
  status: :active,
  supergroup: subcorpus_1
)
tom_n_huck = Group.create!(
  name_en: 'Tom & Huck',
  name_ka: 'ტომი და ჰაკი',
  status: :active,
  supergroup: subcorpus_1
)
euclid_n_rivals = Group.create!(
  name_en: 'Euclid and His Modern Rivals',
  name_ka: 'ევკლიდე და მისი თანამედროვე მეტოქეები',
  status: :active,
  supergroup: subcorpus_1
)

alice_in_wonderland = Collection.create!(
  name_en: 'Alice in Wonderland',
  name_ka: 'ელისი საოცრებათა ქვეყანაში',
  status: :active,
  group: alice
)
through_the_looking_glass = Collection.create!(
  name_en: 'Through the Looking Glass',
  name_ka: 'სარკისმიღმეთში',
  status: :active,
  group: alice
)
tom_sawyer = Collection.create!(
  name_en: 'The Adventures of Tom Sawyer',
  name_ka: 'ტომ სოიერის თავგადასავლები',
  status: :active,
  group: tom_n_huck
)
huck_finn = Collection.create!(
  name_en: 'Adventures of Hucklberry Finn',
  name_ka: 'ჰაკლბერი ფინის თავგადასავალი',
  status: :active,
  group: tom_n_huck
)
euclid_and_his_rivals = Collection.create!(
  name_en: 'Euclid and His Modern Rivals',
  name_ka: 'ევკლიდე და მისი თანამედროვე მეტოქეები',
  status: :active,
  group: euclid_n_rivals
)
