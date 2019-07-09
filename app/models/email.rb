class Email < ApplicationRecord
  belongs_to :user, optional: true
  has_many :replies

  validates :from, :to, :subject, :text, presence: true
end
