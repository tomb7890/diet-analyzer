class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  GENDER_MALE = 'male'
  GENDER_FEMALE = 'female'
  GENDER_LACT = 'female_lact'
  GENDER_PREG = 'female_preg'
  ACTIVITY_LEVELS = [["None", 1.0], ["Sedentary", 1.2], ["Lightly Active", 1.4], ["Moderately Active", 1.6], ["Very Active", 1.8]].freeze
  
  has_many :days, dependent: :destroy
  has_many :foods, through: :days


  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

end
