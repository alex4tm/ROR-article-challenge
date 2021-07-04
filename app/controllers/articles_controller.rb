class ArticlesController < ApplicationController

    after_action :scrape_link, only: [:create]

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
    words_per_minute = 150
      if @article.body
        @reading_time = (@article.body.size / words_per_minute)
      end
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :source_link)
  end

  def scrape_link
    url = @article.source_link
    html_file = URI.open(url).read
    html_doc = Nokogiri::HTML(html_file)
    body = []
    html_doc.css("body").collect do |element|
      body << element.css('h1').children.text
      body << element.css('h2').children.text
      body << element.css('h3').children.text
      body << element.css('p').children.text
    end
    @article.body = "#{body}"
    @article.save!
  end
end
