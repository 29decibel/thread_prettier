class InviteCode < ActiveRecord::Base
  validate :code,:presence=>true,:uniqueness=>true
  scope :not_used,where('used=?',false)
end
