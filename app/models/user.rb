class User < ActiveRecord::Base

  GENDER_MALE = 'male'
  GENDER_FEMALE = 'female'
  GENDER_LACT = 'female_lact'
  GENDER_PREG = 'female_preg'
  
  has_many :days, dependent: :destroy
  has_many :foods, through: :days

  authenticates_with_sorcery!

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

end
