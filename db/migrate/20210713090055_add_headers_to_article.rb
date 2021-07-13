class AddHeadersToArticle < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :headers, :text, array: true, default: []
  end
end
