class Reply < ApplicationRecord
  belongs_to :user
  belongs_to :email

  validates :text, presence: true
end
