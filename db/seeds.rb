# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'csv'

puts 'Create users'

User.find_or_create_by(email: 'babdusi+pc@gmail.com') do |user|
  user.password = '13572468'
  user.password_confirmation = '13572468'
  user.role = :superadmin
end

puts 'Create subcorpus'

subcorpus = Supergroup.find_or_create_by(name_en: 'Subcorpus 1') do |supergroup|
  supergroup.name_ka = 'ქვეკორპუსი 1'
  supergroup.status = :active
end

root_path = 'storage/corp-dictge-db-20240220/'

# Authors

puts 'Create authors'

authors = []

CSV.foreach(
  File.join(root_path, 'subdata_authors.csv'),
  headers: true,
  header_converters: :symbol
) do |row|
  author = Author.find_or_initialize_by(old_id: row[:id])
  author.name_ka = row[:name_ka]
  author.name_en = row[:name_en]
  author.status = row[:status].to_sym
  author.comment = row[:comment]
  raise "Author not valid with old id: #{row[:id]}" unless author.valid?
  authors << author
end

Author.transaction do
  authors.each(&:save!)
end

# Genres

puts 'Create genres'

genres = []

CSV.foreach(
  File.join(root_path, 'subdata_genres.csv'),
  headers: true,
  header_converters: :symbol
) do |row|
  genre = Genre.find_or_initialize_by(old_id: row[:id])
  genre.name_ka = row[:name_ka]
  genre.name_en = row[:name_en]
  genre.status = row[:status].to_sym
  genre.comment = row[:comment]
  raise "Genre not valid with old id: #{row[:id]}" unless genre.valid?
  genres << genre
end

Genre.transaction do
  genres.each(&:save!)
end

# Translators

puts 'Create translators'

translators = []

CSV.foreach(
  File.join(root_path, 'subdata_translators.csv'),
  headers: true,
  header_converters: :symbol
) do |row|
  translator = Translator.find_or_initialize_by(old_id: row[:id])
  translator.name_ka = row[:name_ka]
  translator.name_en = row[:name_en]
  translator.status = row[:status].to_sym
  translator.comment = row[:comment]
  raise "Translator not valid with old id: #{row[:id]}" unless translator.valid?
  translators << translator
end

Translator.transaction do
  translators.each(&:save!)
end

# Types

puts 'Create types'

types = []

CSV.foreach(
  File.join(root_path, 'subdata_types.csv'),
  headers: true,
  header_converters: :symbol
) do |row|
  type = Type.find_or_initialize_by(old_id: row[:id])
  type.name_ka = row[:name_ka]
  type.name_en = row[:name_en]
  type.status = row[:status].to_sym
  type.comment = row[:comment]
  raise "Type not valid with old id: #{row[:id]}" unless type.valid?
  types << type
end

Type.transaction do
  types.each(&:save!)
end

# Groups

puts 'Create groups'

groups = []

CSV.foreach(
  File.join(root_path, 'data_groups.csv'),
  headers: true,
  header_converters: :symbol
) do |row|
  group = Group.find_or_initialize_by(old_id: row[:id])
  group.name_ka = row[:name_ka]
  group.name_en = row[:name_en]
  group.status = row[:status].to_sym
  group.comment = row[:comment]
  group.supergroup = subcorpus
  raise "Group not valid with old id: #{row[:id]}" unless group.valid?
  groups << group
end

Group.transaction do
  groups.each(&:save!)
end

# Collections

puts 'Create collections'

collections = []

CSV.foreach(
  File.join(root_path, 'data_sets.csv'),
  headers: true,
  header_converters: :symbol
) do |row|
  collection = Collection.find_or_initialize_by(old_id: row[:id])
  collection.name_ka = row[:name_ka]
  collection.name_en = row[:name_en]
  collection.status = row[:status].to_sym
  collection.comment = row[:comment]
  collection.additional_info = row[:additional_info]
  collection.year = row[:year]
  collection.translation_year = row[:trans_year]
  collection.group = Group.find_by(old_id: row[:group_id])
  collection.authors = [Author.find_by(old_id: row[:author_id])] if row[:author_id]
  collection.translators = [Translator.find_by(old_id: row[:trans_author_id])]
  collection.genres = [Genre.find_by(old_id: row[:genre_id])]
  collection.types = [Type.find_by(old_id: row[:type_id])]
  raise "Collection not valid with old id: #{row[:id]}" unless collection.valid?
  collections << collection
end

Collection.transaction do
  collections.each(&:save!)
end

# Text blocks

puts 'Create text blocks'

puts '  Reading CSV'

rows = []

CSV.foreach(
  File.join(root_path, 'data_texts.csv'),
  headers: true,
  header_converters: :symbol
) do |row|
  rows << row.to_h
end

puts '  Sorting rows'

rows.sort_by!{ |row| [row[:set_id].to_i, row[:id].to_i] }

puts '  Creating text blocks'

start_from_collection = 0
last_collection_id = -1
collection = nil

order_number = -1

rows.each do |row|
  next if row[:set_id].to_i < start_from_collection
  if row[:set_id].to_i == last_collection_id
    order_number += 1
  elsif row[:set_id].to_i > last_collection_id
    last_collection_id = row[:set_id].to_i
    collection = Collection.find_by(old_id: row[:set_id])
    order_number = 0
    puts "    collection ##{collection.old_id}"
  else
    raise "rows are not sorted #{collection.old_id}, #{row[:set_id]}, #{last_collection_id}"
  end

  text_block_ka = TextBlock.find_or_initialize_by(old_id: row[:id], language: :ka)
  text_block_ka.collection = collection
  text_block_ka.contents = row[:ka]
  text_block_ka.order_number = order_number
  raise "Text block ka not valid with old id: #{row[:id]}, error: #{text_block_ka.errors.full_messages}" unless text_block_ka.valid?

  text_block_en = TextBlock.find_or_initialize_by(old_id: row[:id], language: :en)
  text_block_en.collection = collection
  text_block_en.contents = row[:en]
  text_block_en.order_number = order_number
  raise "Text block en not valid with old id: #{row[:id]}, error: #{text_block_en.errors.full_messages}" unless text_block_en.valid?
  text_block_ka.save!
  text_block_en.save!
end

# Terms

puts 'Create terms'

terms = []

CSV.foreach(
  File.join(root_path, 'data_extension_termins.csv'),
  headers: true,
  header_converters: :symbol
) do |row|
  term = Term.find_or_initialize_by(old_id: row[:id])
  term.term = row[:termin]

  text_block_ka = TextBlock.find_by(old_id: row[:text_id], language: :ka)
  text_block_en = TextBlock.find_by(old_id: row[:text_id], language: :en)

  if text_block_ka.contents.include?(term.term)
    term.text_block = text_block_ka
  elsif text_block_en.contents.include?(term.term)
    term.text_block = text_block_en
  else
    raise "Term not found with old id: #{row[:id]}"
  end

  raise "Term not valid with old id: #{row[:id]}" unless term.valid?
  terms << term
end

Term.transaction do
  terms.each(&:save!)
end
