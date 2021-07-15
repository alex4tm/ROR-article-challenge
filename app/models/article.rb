class Article < ActiveRecord::Base
  validates :title, presence: true
  url_regex = URI::DEFAULT_PARSER.make_regexp(%w[http https])
  validates :source_link,
            presence: true,
            format: { with: url_regex, message: 'url not valid !!' }
  after_create :scrape_link, :shorten_link

  include PgSearch::Model
  pg_search_scope :search_by_title_headers_and_body,
                  against: {
                    title: 'A',
                    headers: 'B',
                    body: 'C'
                  },
                  using: {
                    tsearch: { prefix: true }
                  },
                  ranked_by: ':tsearch / 2.0'

  def scrape_link
    url = source_link
    html_file = URI.open(url).read
    html_doc = Nokogiri::HTML(html_file)
    headers = []
    body = ''
    html_doc.css('body').collect do |element|
      headers << element.css('h1').children.text
      headers << element.css('h2').children.text
      headers << element.css('h3').children.text
      body = element.css('p').children.text
    end
    self.body = body.to_s
    self.headers = headers.to_s
    save
    self.reading_time = (self.body.split(' ').size / 120)
    save
  end

  def shorten_link
    client = Bitly::API::Client.new(token: ENV['BITLY_TOKEN'])
    bitlink = client.shorten(long_url: source_link)
    self.short_link = bitlink.link
    self.views = bitlink.clicks_summary.total_clicks
    save
  end
end
