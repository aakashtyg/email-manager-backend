class AddFromEmailToReplies < ActiveRecord::Migration[5.2]
  def change
    add_column :replies, :from_email, :string
  end
end
