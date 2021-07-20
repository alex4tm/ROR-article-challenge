require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  test "should not save article without title" do
    article = Article.new
    assert_not article.save
  end
  test "should not save article without source link" do
    article = Article.new(title: 'title')
    assert_not article.save
  end
  test "article should have a body after create" do
    #testing if scrape works
    article = Article.create(title: 'title', source_link: 'https://redux.js.org/introduction/getting-started' )
    assert article.short_link != ""
  end
  test "article should have a short link after create" do
    #testing if creating short link method works
    article = Article.create(title: 'title', source_link: 'https://redux.js.org/introduction/getting-started' )
    assert article.short_link != ""
  end
end
