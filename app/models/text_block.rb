class TextBlock < ApplicationRecord
  include Discardable

  belongs_to :collection
  has_one :group, through: :collection
  has_one :supergroup, through: :group
  has_many :text_block_component_pivots, dependent: :destroy
  has_many :text_block_components, through: :text_block_component_pivots
  has_many :terms, dependent: :destroy

  enum language: { ka: 0, en: 1 }

  scope :georgian, -> { where(language: :ka).order(:order_number) }
  scope :english, -> { where(language: :en).order(:order_number) }

  def self.one_lang_simple_search(query)
    where('contents LIKE ?', "%#{query}%").order(:collection_id, :order_number)
  end

  def self.simple_search(query)
    results = one_lang_simple_search(query)

    order_numbers = results.pluck(:order_number)
    collection_ids = results.pluck(:collection_id)
    zipped = order_numbers.zip(collection_ids)

    where(order_number: order_numbers, collection_id: collection_ids)
      .order(:collection_id, :order_number, :language)
      .select { |text_block| zipped.include?([text_block.order_number, text_block.collection_id]) }
  end

  def self.word_count_by_language
    query = "SELECT SUM(word_count) AS count, language
             FROM (SELECT COUNT(*) AS word_count, language
                   FROM text_blocks
                   INNER JOIN collections ON text_blocks.collection_id = collections.id AND collections.status = 0
                   INNER JOIN groups ON collections.group_id = groups.id AND groups.status = 0
                   INNER JOIN supergroups ON groups.supergroup_id = supergroups.id AND supergroups.status = 0
                   INNER JOIN text_block_component_pivots ON text_blocks.id = text_block_component_pivots.text_block_id
                   GROUP BY language) AS word_counts
             GROUP BY language;"

    result = ActiveRecord::Base.connection.execute(query)
    result_hash = {}
    result.each do |row|
      result_hash[languages.key(row['language'].to_i).to_sym] = NumbersFormattingService.call(row['count'].to_i)
    end
    result_hash
  end

  def serialize
    JSON.generate(as_json)
  end

  def en_contents
    read_attribute(:en_contents)
  end
end
