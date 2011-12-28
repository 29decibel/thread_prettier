#coding: utf-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:invite_code

  has_many :favorates
  has_many :resource_infos,:through=>:favorates
  validate :invite_code,:presence=>true
  validate :invite_code_valide

  after_create :invalid_invite_code

  private
  def invite_code_valide
    self.errors.add(:invite_code,'无效') if !InviteCode.valid.where('code=?',self.invite_code).any?
  end

  def invalid_invite_code
    ic = InviteCode.find_by_code(self.invite_code)
    ic.update_attribute(:valid,false) if ic
  end

end
