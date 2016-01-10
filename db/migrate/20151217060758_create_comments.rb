class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :video_id
      t.integer :user_id
      t.integer :rate
      t.text  :review
      t.timestamps
    end
  end
end
