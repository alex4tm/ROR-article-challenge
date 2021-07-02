class Article < ApplicationRecord
  validates :title, :source_link, presence: true
end
