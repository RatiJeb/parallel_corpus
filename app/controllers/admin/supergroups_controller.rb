class Admin::SupergroupsController < Admin::BaseController

  def index
    @supergroups = Supergroup.all
  end

end
