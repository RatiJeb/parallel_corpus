module Search
  class TextBlock
    include ActiveModel::Model

    attr_accessor :original_id, :original_contents, :translation_contents
  end
end
