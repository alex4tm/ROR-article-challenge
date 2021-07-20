require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_path
    assert_response :success
  end

  test "should create article" do
    assert_difference("Article.count") do
      post articles_path, params: { article: { source_link: "https://redux.js.org/introduction/getting-started", title: "New Article" } }
    end
    assert_redirected_to root_path
    assert_equal "Article was successfully created.", flash[:notice]
  end

  test "should show article" do
    article = articles(:one)
    get article_path(article)
    assert_response :success
  end
end
