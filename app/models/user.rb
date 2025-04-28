class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles
  accepts_nested_attributes_for :user_roles
  belongs_to :department, optional: true
  has_one :user_info, dependent: :destroy
  accepts_nested_attributes_for :user_info
  has_many :job_employments, dependent: :destroy
  accepts_nested_attributes_for :job_employments
  has_many :asset_details, dependent: :destroy
  accepts_nested_attributes_for :asset_details, allow_destroy: true
  has_many :bank_details, dependent: :destroy
  accepts_nested_attributes_for :bank_details, allow_destroy: true
  def active_for_authentication?
    super && active?
  end
end
