module Search
  class TextBlock
    include ActiveModel::Model

    attr_accessor :collection_id, :original_id, :original_contents, :translation_contents, :order_number
  end
end
