class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
    @body = scrape_link(@article)
    words_per_minute = 150
    @reading_time = (@body.size / words_per_minute)
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

  def scrape_link(article)
    url = article.source_link
    html_file = URI.open(url).read
    html_doc = Nokogiri::HTML(html_file)
    body = []
    headers = []
    html_doc.css("body").collect do |element|
      headers << element.css('h1')
      headers << element.css('h2')
      headers << element.css('h3')
      body << element.css('p')
      return "#{headers.join(' ')} + #{body.join(' ')}"
    end
  end
end
