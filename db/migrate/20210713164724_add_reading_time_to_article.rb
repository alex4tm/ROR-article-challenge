class AddReadingTimeToArticle < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :reading_time, :string
  end
end
