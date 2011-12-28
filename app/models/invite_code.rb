class InviteCode < ActiveRecord::Base
  validate :code,:presence=>true,:uniqueness=>true
  scope :valid,where('valid=?',true)
end
