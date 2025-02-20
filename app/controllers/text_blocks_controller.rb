class TextBlocksController < ApplicationController
  before_action :set_search_params, only: [:advanced_search]

  def index
    @result = CacheService.get('text_blocks_count') || text_blocks_count
  end

  def search
    @text_block_pairs = TextBlock
                          .select(' COALESCE(text_blocks.id, tb_en.id) AS id,
                                    COALESCE(text_blocks.collection_id, tb_en.collection_id) AS collection_id,
                                    COALESCE(text_blocks.order_number, tb_en.order_number) AS order_number,
                                    text_blocks.contents,
                                    tb_en.contents AS en_contents')
                          .includes(
                            collection:
                              [
                                :group,
                                { collection_authors: :author },
                                { collection_fields: :field },
                                { collection_genres: :genre },
                                { collection_publishings: :publishing },
                                { collection_translators: :translator },
                                { collection_types: :type },
                              ],
                          )
                          .joins(collection: { group: :supergroup })
                          .joins(matched_text_blocks_sql)
                          .joins(en_text_blocks_sql)
                          .merge(Collection.active)
                          .merge(Group.active)
                          .merge(Supergroup.active)
                          .where(language: :ka)
                          .order(:collection_id, :order_number)
                          .page(params[:page])
                          .per(20)
                          .load
  end

  def advanced_search
    @text_block_pairs = TextBlock
    @text_block_pairs = @text_block_pairs.none.page(0) if filter_params_missing?
    @text_block_pairs = @text_block_pairs
                          .select(' COALESCE(text_blocks.id, tb_en.id) AS id,
                                    COALESCE(text_blocks.collection_id, tb_en.collection_id) AS collection_id,
                                    COALESCE(text_blocks.order_number, tb_en.order_number) AS order_number,
                                    text_blocks.contents,
                                    tb_en.contents AS en_contents')
                          .joins(en_text_blocks_sql)
                          .joins(matched_text_blocks_sql)

    @text_block_pairs = @text_block_pairs.includes(collection: %i[group authors translators types genres fields publishings])
    @text_block_pairs = @text_block_pairs.where(collection: Collection.where(group: Group.where(supergroup: Supergroup.where(status: :active), status: :active), status: :active))

    if params[:collocations].present?
      first_id = TextBlockComponent.find_by(value: params[:collocations][:first])&.id
      second_id = TextBlockComponent.find_by(value: params[:collocations][:second])&.id
      @text_block_pairs = @text_block_pairs.where(id: TextBlockComponentPivot.joins("INNER JOIN text_block_component_pivots p2 on text_block_component_pivots.text_block_id = p2.text_block_id and text_block_component_pivots.text_block_component_id = #{first_id} AND p2.text_block_component_id = #{second_id} AND text_block_component_pivots.position + 1 = p2.position").select(:text_block_id))
    end

    if params[:original_language].present? && params[:original_language] != 'both'
      @text_block_pairs = @text_block_pairs
                            .where(collection: { original_language: params[:original_language] == 'ka' ? 0 : 1 })
    end

    @text_block_pairs = @text_block_pairs.where(collection: { year: params[:year_start]..params[:year_end] }) if params[:year_start].present? || params[:year_end].present?
    @text_block_pairs = @text_block_pairs.where(collection: { translation_year: params[:translation_year_start]..params[:translation_year_end] }) if params[:translation_year_start].present? || params[:translation_year_end].present?

    if params[:search_text_block_pair].present?
      @text_block_pairs = @text_block_pairs.where(collections: { groups: { supergroup_id: params[:search_text_block_pair][:supergroup_ids] } }) if params[:search_text_block_pair][:supergroup_ids]&.any?(&:present?)
      @text_block_pairs = @text_block_pairs.where(collection: { group_id: params[:search_text_block_pair][:group_ids] }) if params[:search_text_block_pair][:group_ids]&.any?(&:present?)
      @text_block_pairs = @text_block_pairs.where(collection_id: params[:search_text_block_pair][:collection_ids]) if params[:search_text_block_pair][:collection_ids]&.any?(&:present?)

      collections = Collection.active.joins(group: :supergroup).merge(Group.active).merge(Supergroup.active)
      @text_block_pairs = @text_block_pairs.where(collection: collections.matching_authors(params[:search_text_block_pair][:author_ids])) if params[:search_text_block_pair][:author_ids]&.any?(&:present?)
      @text_block_pairs = @text_block_pairs.where(collection: collections.matching_fields(params[:search_text_block_pair][:field_ids])) if params[:search_text_block_pair][:field_ids]&.any?(&:present?)
      @text_block_pairs = @text_block_pairs.where(collection: collections.matching_genres(params[:search_text_block_pair][:genre_ids])) if params[:search_text_block_pair][:genre_ids]&.any?(&:present?)
      @text_block_pairs = @text_block_pairs.where(collection: collections.matching_publishings(params[:search_text_block_pair][:publishing_ids])) if params[:search_text_block_pair][:publishing_ids]&.any?(&:present?)
      @text_block_pairs = @text_block_pairs.where(collection: collections.matching_translators(params[:search_text_block_pair][:translator_ids])) if params[:search_text_block_pair][:translator_ids]&.any?(&:present?)
      @text_block_pairs = @text_block_pairs.where(collection: collections.matching_types(params[:search_text_block_pair][:type_ids])) if params[:search_text_block_pair][:type_ids]&.any?(&:present?)
    end

    @text_block_pairs = @text_block_pairs.order(:id).page(params[:page]).per(20)
  end

  private

  def set_search_params
    @search = Search::TextBlockPair.new(
      params.permit(
        :query, :exact_match, :original_language, :year_start, :year_end, :translation_year_start,
        :translation_year_end, collocations: %i[first second], search_text_block_pair:
          {
            supergroup_ids: [], group_ids: [], collection_ids: [],
            type_ids: [], field_ids: [], genre_ids: [], author_ids: [],
            translator_ids: [], publishing_ids: []
          }
      ),
    )
  end

  def search_params
    params.permit(:query)
  end

  def text_blocks_count
    supergroup_id = Supergroup.where(status: :active).pluck(:id)
    group_id = Group.where(status: :active, supergroup_id:).pluck(:id)
    collection_id = Collection.where(status: :active, group_id:).pluck(:id)
    pairs_count = TextBlock
                    .joins("FULL OUTER JOIN text_blocks tb_1
                            ON text_blocks.collection_id = tb_1.collection_id
                            AND text_blocks.order_number = tb_1.order_number
                            AND text_blocks.language != tb_1.language")
                    .joins(collection: { group: :supergroup })
                    .merge(Collection.active)
                    .merge(Group.active)
                    .merge(Supergroup.active)
                    .where('text_blocks.language = 0 OR text_blocks.language IS NULL')
                    .group(:collection_id, :order_number)
                    .count.count
    value = {
      pairs: ::NumbersFormattingService.call(pairs_count),
      collections: ::NumbersFormattingService.call(collection_id.size),
      groups: ::NumbersFormattingService.call(group_id.size),
      words: TextBlock.word_count_by_language,
    }
    CacheService.set('text_blocks_count', value, DateTime.current + 2.hours)
    value
  end

  def filter_params_missing?
    !(params[:query].present? || params[:collocations].present? || params[:collections].present? ||
      params[:translators].present? || params[:year_start].present? || params[:year_end].present? ||
      params[:translation_year_start].present? || params[:translation_year_start].present? ||
      params[:search_text_block_pair]&.values&.flatten&.select(&:present?).present?)
  end

  def en_text_blocks_sql
    <<~SQL
      FULL OUTER JOIN text_blocks tb_en
        ON tb_en.order_number = text_blocks.order_number
        AND tb_en.collection_id = text_blocks.collection_id
        AND tb_en.language != text_blocks.language
    SQL
  end

  def matched_text_blocks_sql
    return if params[:query].blank?

    <<~SQL
      INNER JOIN (SELECT tb.collection_id, tb.order_number
            FROM text_blocks tb
            LEFT JOIN text_blocks tb_1
              ON tb.collection_id = tb_1.collection_id
              AND tb.order_number = tb_1.order_number
              AND tb.language != tb_1.language
            WHERE tb.contents ~* '#{match_regex}'
            GROUP BY tb.collection_id, tb.order_number) text_block_match
              ON text_blocks.order_number = text_block_match.order_number
              AND text_blocks.collection_id = text_block_match.collection_id
              AND text_blocks.language = 0
    SQL
  end

  def match_regex
    params[:exact_match].to_s == '1' ? "(^|[^a-zA-Z0-9ა-ჰ-])#{params[:query]}($|[^a-zA-Z0-9ა-ჰ-])" : params[:query]
  end
end
