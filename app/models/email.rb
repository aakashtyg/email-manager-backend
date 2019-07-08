class Email < ApplicationRecord
  belongs_to :user

  validates :from, :to, :subject, :text, presence: true
end
