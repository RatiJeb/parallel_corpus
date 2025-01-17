class CreateFeedbacks < ActiveRecord::Migration[7.1]
  def change
    create_table :feedbacks do |t|
      t.string :first_name, limit: 50, null: false
      t.string :last_name, limit: 50, null: false
      t.string :email, limit: 100, null: false
      t.string :subject, limit: 255, null: false
      t.text :content, limit: 10_000, null: false
      t.boolean :read, default: false, null: false

      t.timestamps
    end
  end
end
