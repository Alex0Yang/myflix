class ChangeReviewToContent < ActiveRecord::Migration
  def change
    rename_column :comments, :review, :content
  end
end
