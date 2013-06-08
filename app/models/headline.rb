class Headline < ActiveRecord::Base
	require 'nokogiri'
	require 'open-uri'

	# 'Scrape' the text of tags specified by css selectors using Nokogiri
	# @param agencies. Array of all news agencies from which to scrape link text.
	# @param limit. The limit on the number of stories displayed.
	# @param scraper_options. A nested hash containing the hostname URI's, as well as headline and story css selectors for each agency.
	# @return stories. A hash with three keys (:text, :href, and :uri) with @limit number of stories.
	def self.scrape(agencies = [:cnn], limit = 25, scraper_options)
    stories = {}
    agencies.size.times do |i| 
		  url, headline, other_stories = scraper_options[:base_urls][agencies[i]], scraper_options[:headlines][agencies[i]], scraper_options[:other_stories][agencies[i]]
      text, href, doc = [], [], Nokogiri::HTML(open(url))
  	  text << doc.at_css(headline).text  unless doc.at_css(headline).nil? 
      href << doc.at_css(headline)[:href] unless doc.at_css(headline).nil?  
  	  doc.css(other_stories).each_with_index do |link, j| 
  		  j >= limit ? break : j += 1	
  		  text << link.at_css("a").text unless link.at_css("a").nil? 
        href << link.at_css("a")[:href] unless link.at_css("a").nil?
  	  end
      stories[agencies[i]] = {:text => text}
      stories[agencies[i]][:href] = href
      stories[agencies[i]][:uri] = url
    end
  	return stories
  end

  # Specifies hostname URI's and CSS selectors for headlines and other stories for each news agency.
  # These settings are crucial to allow Headline::scrape to select the correct link text from each news source.
  # @return scraper_options. A hash, which can be called as such: scraper_options[setting][agency].
  def self.scraper_options
  	scraper_options = {
  		:base_urls => {
  			:cnn => "http://www.cnn.com/", :reuters => "http://www.reuters.com/", :chinadaily => "http://www.chinadaily.com.cn/china/", :bbc => "http://www.bbc.com/news/", :aljazeera => "http://www.aljazeera.com/"
  		},
  		:headlines => {
  			:cnn => ".cnn_banner_standard h1 a, .cnn_banner_large h1 a", :reuters => ".topStory h2 a", :chinadaily => ".font28 a", :bbc => ".top-story-header a", :aljazeera => "#ctl00_cphBody_ctl00_rptNews_ctl00_lnkTitle"
  		}, 
  		:other_stories => {
  			:cnn => ".cnn_bulletbin li", :reuters => "h2 + h2, h2 ~ h2, h2:not(:first-child), h2", :chinadaily => "#main2 li, .headline-box h2, :nth-child(3) .wid300 h3", :bbc => "#top-story li, #second-story h2, #second_story li, 
				.secondary-story-header, #third-story li, #other-top-stories h3", :aljazeera => ".indexText-Font2 h2, .h89-fix td div:first-child, .rightNewsArea, #ctl00_cphBody_ctl02_ctl01_DataList1_ctl00_Thumbnail1_Layout14 > div:nth-child(2), 
				#ctl00_cphBody_ctl02_ctl01_DataList1_ctl01_Thumbnail1_Layout14 > div:nth-child(2), #ctl00_cphBody_ctl02_ctl01_DataList1_ctl02_Thumbnail1_Layout14 > div:nth-child(2), #ctl00_cphBody_ctl02_ctl01_DataList1_ctl03_Thumbnail1_Layout14 > div:nth-child(2), #ctl00_cphBody_ctl03_rptPosting_ctl01_Thumbnail1_Layout9 > div:nth-child(2), 
				#ctl00_cphBody_ctl03_rptPosting_ctl02_Thumbnail1_Layout9 > div:nth-child(2), #ctl00_cphBody_ctl03_rptPosting_ctl03_Thumbnail1_Layout9 > div:nth-child(2), .skyscLines, .skyscBullet, #ctl00_cphBody_ctl05_ctl01_DataList1_ctl00_Thumbnail1_Layout14 div , #ctl00_ctl00_MostViewedArticles1_dvMVAlayout1 :nth-child(10)"
			}
  	}
  end

  # Specifies each agency from which to scrape headline stories
  def self.agencies
    return [:cnn, :reuters, :aljazeera, :bbc, :chinadaily]
  end

end
