class Article < ApplicationRecord
  validates :title, :source_link, presence: true
  validates_format_of :source_link, :with => /\A(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w\.-]*)*\/?\Z/i
end
