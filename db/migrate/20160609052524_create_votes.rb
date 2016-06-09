class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :comment
      t.boolean :up
      t.references :user
      t.timestamps null: false
    end
  end
end
