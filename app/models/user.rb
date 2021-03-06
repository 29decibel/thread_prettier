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
  has_many :user_rates
  validate :invite_code,:presence=>true
  validate :invite_code_valide

  after_create :invalid_invite_code

  def name
    self.email
  end

  private
  def invite_code_valide
    self.errors.add(:invite_code,'无效') if !InviteCode.not_used.where('code=?',self.invite_code).any?
  end

  def invalid_invite_code
    ic = InviteCode.find_by_code(self.invite_code)
    ic.update_attribute(:used,true) if ic
  end

end
