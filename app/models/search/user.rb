module Search
  class User
    include ActiveModel::Model

    attr_accessor :id, :email, :role

    def attributes
      instance_values
    end
  end
end
