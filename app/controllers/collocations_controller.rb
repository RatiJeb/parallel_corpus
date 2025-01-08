# frozen_string_literal: true

class CollocationsController < ApplicationController
  def index
    @collocations_data = {}

    return unless params[:query].present?

    @collocations_data[:all_count] = TextBlockComponentPivot.count
    @collocations_data[:first_count] = TextBlockComponentPivot
                                         .joins(:text_block_component)
                                         .where(text_block_components: { value: params[:query].downcase })
                                         .count
    @collocations_data[:left] = collocations_data
    @collocations_data[:right] = collocations_data(:right)
    set_total_counts
  end

  private

  def collocations_data(type = :left)
    TextBlockComponentPivot
      .joins(:text_block_component)
      .joins("INNER JOIN text_block_component_pivots AS collocate_pivots ON collocate_pivots.position = text_block_component_pivots.position #{ type == :left ? '-' : '+' } 1 and collocate_pivots.text_block_id = text_block_component_pivots.text_block_id")
      .joins('INNER JOIN text_block_components collocate_components ON collocate_pivots.text_block_component_id = collocate_components.id')
      .where(text_block_components: { value: params[:query].downcase })
      .group('collocate_components.id')
      .order('both_count DESC')
      .select(select_sql)
      .page(params[:page] || 0)
      .per(params[:page_limit] || 150)
  end

  def select_sql
    <<~SQL
      collocate_components.id,
      collocate_components.value,
      count(*) as both_count,
      (SELECT COUNT(*) FROM text_block_component_pivots WHERE text_block_component_id = collocate_components.id) AS second_count
    SQL
  end

  def set_total_counts
    query = params[:query]
    %i[left right].each do |type|
      @collocations_data[type].define_singleton_method(:total_count) do |*args|
        Rails.cache.fetch("collocate_components_#{type}_#{query}", expires_in: 5.minutes) { super(*args) }
      end
    end
  end
end
