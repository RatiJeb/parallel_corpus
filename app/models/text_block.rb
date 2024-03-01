class TextBlock < ApplicationRecord
  belongs_to :collection

  enum language: [:ka, :en]

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

end
