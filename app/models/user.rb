class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_attached_file :certificate
  validates_attachment_content_type :certificate, :content_type => "application/pdf"

  has_many :customers
  has_many :suppliers
  has_many :product_descriptions
  has_many :purchase_orders
  has_many :sales_orders
  has_many :email_recipients
end
