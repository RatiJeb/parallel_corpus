class TextBlock < ApplicationRecord
  include Discardable

  belongs_to :collection
  has_one :group, through: :collection
  has_one :supergroup, through: :group

  enum language: [:ka, :en]

  scope :georgian, -> { where(language: :ka).order(:order_number) }
  scope :english, -> { where(language: :en).order(:order_number) }

  def self.one_lang_simple_search(query)
    where("contents LIKE ?", "%#{query}%").order(:collection_id, :order_number)
  end

  def self.simple_search(query)
    results = one_lang_simple_search(query)

    order_numbers = results.pluck(:order_number)
    collection_ids = results.pluck(:collection_id)
    zipped = order_numbers.zip(collection_ids)

    where(
      order_number: order_numbers, collection_id: collection_ids
    ).order(
      :collection_id, :order_number, :language
    ).select { |text_block| zipped.include?([
      text_block.order_number, text_block.collection_id
      ])
    }
  end

  def serialize
    JSON.generate(as_json)
  end

end
