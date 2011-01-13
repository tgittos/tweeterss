require 'rss'
require 'open-uri'
require 'date'

class TweeterssRss
    
    attr_accessor :entries
    
    def initialize(uri, timestamp)
        @uri = uri
        @timestamp = timestamp
        fetch
    end
          
    def fetch
        rss_content = ""
        open(@uri) do |f|
            rss_content = f.read
        end
        parse(RSS::Parser.parse(rss_content, false))
    end
    
    private

        def parse(rss)
            @entries = Array.new
            rss.items.each do |i|
	    	date = DateTime.parse i.pubDate.to_s
                if !@timestamp.nil? and date < @timestamp
                    next
                end
                @entries << i.description
            end
        end
    
end
