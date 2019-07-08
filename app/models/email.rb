class Email < ApplicationRecord
  belongs_to :user, optional: true

  validates :from, :to, :subject, :text, presence: true
end
