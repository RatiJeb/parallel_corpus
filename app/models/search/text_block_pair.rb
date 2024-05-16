module Search
  class TextBlockPair
    include ActiveModel::Model

    attr_accessor :query, :termin, :original_language, :supergroup_ids,
                  :group_ids, :collection_ids, :type_ids, :field_ids,
                  :genre_ids, :year_start, :year_end, :translation_year_start,
                  :translation_year_end, :author_ids, :translator_ids,
                  :publishing_ids

    def attributes
      instance_values
    end
  end
end
