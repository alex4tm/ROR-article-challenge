# frozen_string_literal: true

# articles controller
class ArticlesController < ApplicationController
  def index
    @articles = if params[:query].present?
                  Article.search_by_title_headers_and_body(params[:query])
                else
                  Article.all
                end
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.valid?
      @article.save
      redirect_to root_path
    else
      flash.now[:messages] = @article.errors.full_messages[0]
      render :new
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :source_link, :query)
  end
end
