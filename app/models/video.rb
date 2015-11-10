class Video < ActiveRecord::Base
  belongs_to :category
  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(search_term)
    unless search_term.blank?
      where("lower(title) like ?", "%#{search_term.downcase}%").order("created_at DESC")
    else
      []
    end
  end
end
