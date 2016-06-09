class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :content_less
      t.text :content_more
      t.string :email
      t.references :topic
      t.timestamps null: false
    end
  end
end
