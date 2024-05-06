module Discardable
  extend ActiveSupport::Concern

  included do
    before_destroy :discard, prepend: true

    def discard
      Garbage.create!(model: self.class.name, snapshot: serialize)
    end
  end

  class_methods do

    def undiscard(garbage)
      garbage.model.constantize.save!(JSON.parse(garbage.snapshot))
    end
  end

end
