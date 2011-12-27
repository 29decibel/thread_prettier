class Favorate < ActiveRecord::Base
  belongs_to :user
  belongs_to :resource_info
  validate :user_id,:uniqueness=>{:scope=>:resource_info_id}
end
