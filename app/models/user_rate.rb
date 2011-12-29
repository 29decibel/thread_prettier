class UserRate < ActiveRecord::Base
  belongs_to :user
  belongs_to :resource_info
  validate :user_id,:uniqueness=>{:scope=>:resource_info_id}
  after_save :update_resource_score

  private
  def update_resource_score
    self.resource_info.update_score
  end
end
