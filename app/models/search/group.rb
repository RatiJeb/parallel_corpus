module Search
  class Group
    include ActiveModel::Model

    attr_accessor :id, :supergroup_id, :supergroup_name_ka, :supergroup_name_en, :name_en, :name_ka, :status

    def attributes
      instance_values
    end
  end
end
