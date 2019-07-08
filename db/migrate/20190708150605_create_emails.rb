class CreateEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.string :from
      t.string :to
      t.string :subject
      t.text :text
      t.string :status
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
