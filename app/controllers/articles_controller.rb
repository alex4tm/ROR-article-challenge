class ArticlesController < ApplicationController
  after_action :scrape_link, :shorten_link, only: [:create]

  def index
    if params[:query].present?
      @articles = Article.search_by_title_headers_and_body(params[:query])
    else
      @articles = Article.all
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

    if @article.save
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :source_link, :query)
  end

  def scrape_link
    url = @article.source_link
    html_file = URI.open(url).read
    html_doc = Nokogiri::HTML(html_file)
    headers = []
    body = []
    html_doc.css('body').collect do |element|
      headers << element.css('h1').children.text
      headers << element.css('h2').children.text
      headers << element.css('h3').children.text
      body << element.css('p').children.text
    end
    @article.body = body.to_s
    @article.headers = headers.to_s
    @article.save!
    @article.reading_time = (@article.body.split(' ').size / 120)
    @article.save!
  end

  def shorten_link
    client = Bitly::API::Client.new(token: ENV['BITLY_TOKEN'])
    bitlink = client.shorten(long_url: @article.source_link)
    @article.short_link = bitlink.link
    @article.views = bitlink.clicks_summary.total_clicks
    @article.save
  end
end
