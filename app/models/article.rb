class Article < ActiveRecord::Base
  validates :title, :source_link, presence: true
  validates_format_of :source_link, :with => /\A(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w\.-]*)*\/?\Z/i
  include PgSearch::Model
  pg_search_scope :search_by_title_headers_and_body,
                  against: {
                    title: 'A',
                    headers: 'B',
                    body: 'C'
                  },
                  using: {
                    tsearch: { prefix: true }
                  },
                  ranked_by: ":tsearch / 2.0"
end
