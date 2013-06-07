class Headline < ActiveRecord::Base
	require 'nokogiri'
	require 'open-uri'

	# Retrieves headlines and other news stories from the news agency specified by @param agency.
	# @param agency. An array of varying news agencies to feed the web scraper
	# @param limit. The limit on the number of stories.
	# @param scraper_options. A nested hash containing the urls, headlines and stories for the news agency.
	# @return an array with the headline and @limit number of stories
	def self.scrape(agencies = [:cnn], limit = 25, scraper_options)
    stories = {}
    agencies.size.times do |i| 
		  url, headline, other_stories = scraper_options[:base_urls][agencies[i]], scraper_options[:headlines][agencies[i]], scraper_options[:other_stories][agencies[i]]
      text, href, doc = [], [], Nokogiri::HTML(open(url))
  	  text << doc.at_css(headline).text  unless doc.at_css(headline).nil? # Appending top headline
      href << doc.at_css(headline)[:href] unless doc.at_css(headline).nil? # Append href attribute of top headline
  	  doc.css(other_stories).each_with_index do |link, j|  # Iterate over other news agency stories with an index
  		  j >= limit ? break : j += 1	# Break iteration when @param limit is reached
  		  text << link.at_css("a").text unless link.at_css("a").nil? # Push link text, href attribute and base url onto stories
        href << link.at_css("a")[:href] unless link.at_css("a").nil?
  	  end
      stories[agencies[i]] = {:text => text}
      stories[agencies[i]][:href] = href
      stories[agencies[i]][:uri] = url
    end
  	return stories
  end

  # Defines 'settings' for base url's and the css selectors for scraping the headlines and other news stories for six different news agencies.
  # @return scraper_options, which can be called as such: scraper_options[setting][agency]
  # @agencies = :cnn, :reuters, :china_daily, :bbc, :aljazeera
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

end
