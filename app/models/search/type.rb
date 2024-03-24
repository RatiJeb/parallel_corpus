module Search
  class Type
    include ActiveModel::Model

    attr_accessor :id, :name_en, :name_ka
  end
end
