class Video < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  index_name ["myflix", Rails.env].join('_')

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

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

  def rating
    comments.average(:rate).round(1) if comments.average(:rate)
  end

  def as_indexed_json(options={})
    as_json(include: { comments: { only: :content} },
      only: [:title, :description])
  end

  def self.search(query, options={})
    fields = ["title^100", "description^50"]
    fields << "comments.content" if options[:comments]
    search_term = {
      query: {
        multi_match: {
          query: query,
          operator: "and",
          fields: fields
        }
      }
    }
    __elasticsearch__.search(search_term)
  end
end
