class AddTimestampVideo < ActiveRecord::Migration
  def change
    change_table :videos do |t|
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
