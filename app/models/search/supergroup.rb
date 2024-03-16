module Search
  class Supergroup
    include ActiveModel::Model

    attr_accessor :id, :name_en, :name_ka, :status
  end
end
