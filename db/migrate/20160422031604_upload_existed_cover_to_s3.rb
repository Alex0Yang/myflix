class UploadExistedCoverToS3 < ActiveRecord::Migration
  def change
    Video.all.each do |video|
      video.remote_large_cover_url = video.old_large_cover_url
      video.remote_small_cover_url = video.old_small_cover_url
      video.save
    end
  end
end
