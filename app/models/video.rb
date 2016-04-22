class Video < ActiveRecord::Base
  mount_uploader :large_cover, CoverUploader
  mount_uploader :small_cover, CoverUploader
  belongs_to :category
  has_many :comments, -> { order('created_at desc') }
  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("lower(title) like ?", "%#{search_term.downcase}%").order("created_at DESC")
  end

  def average_rate
    return 'none' unless comments.present?
    total = 0
    comments.reload.each { |c| total += c.rate }
    ( total * 1.0 / comments.count ).round(1)
  end
end
