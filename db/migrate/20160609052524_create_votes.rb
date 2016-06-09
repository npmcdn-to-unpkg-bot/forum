class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :comment
      t.boolean :up
      t.string :email
      t.timestamps null: false
    end
  end
end
