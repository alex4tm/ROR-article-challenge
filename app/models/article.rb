# frozen_string_literal: true

# article model
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
                  ranked_by: ':tsearch / 2.0',
                  order_within_rank: 'articles.updated_at DESC'

  def scrape_link
    url = source_link
    html_file = URI.parse(url).open.read
    html_doc = Nokogiri::HTML(html_file)
    sheaders = []
    sbody = ''
    html_doc.css('body').collect do |element|
      sheaders << element.css('h1').children.text
      sheaders << element.css('h2').children.text
      sheaders << element.css('h3').children.text
      sbody = element.css('p').children.text
    end
    self.body = sbody
    self.headers = sheaders
    self.reading_time = (sbody.split(' ').size / 120)
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
