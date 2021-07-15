class AddShortLinkToArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :short_link, :string, default: ''
  end
end
