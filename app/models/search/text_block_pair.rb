module Search
  class TextBlockPair
    include ActiveModel::Model

    attr_accessor :query, :termin, :exact_match, :original_language, :supergroup_ids,
                  :group_ids, :collection_ids, :type_ids, :field_ids, :collocations,
                  :genre_ids, :year_start, :year_end, :translation_year_start,
                  :translation_year_end, :author_ids, :translator_ids,
                  :publishing_ids, :search_text_block_pair

    def attributes
      instance_values
    end
  end
end
