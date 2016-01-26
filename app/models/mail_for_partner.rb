class MailForPartner < ActiveRecord::Base
  belongs_to :user
  belongs_to :customer
  belongs_to :supplier 
end
