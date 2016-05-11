class AddCoverToVideos < ActiveRecord::Migration
  def change
    rename_column :videos, :large_cover_url, :old_large_cover_url
    rename_column :videos, :small_cover_url, :old_small_cover_url
    add_column :videos, :large_cover, :string
    add_column :videos, :small_cover, :string
  end
end
