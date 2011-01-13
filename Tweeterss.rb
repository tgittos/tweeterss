__DIR__ = File.dirname(__FILE__)

require 'yaml'
require File.join(__DIR__, 'lib', 'TweeterssRss')
require File.join(__DIR__, 'lib', 'TweeterssTweet')

class Tweeterss

  def initialize(config)
    load_config config
    fetch_feeds
    tweet_entries
    write_timestamp
  end
    
  private
                
    def load_config(config)
      yaml = YAML::load_file config
      parse_config yaml
    end
        
    def parse_config(yaml)
      @username = yaml['twitter']['username']
      @password = yaml['twitter']['password']
      @timestamp_file = File.join(File.dirname(__FILE__), yaml['timestamp'])
	    @delay = yaml['twitter']['delay']
      @feeds = yaml['feeds']
      load_timestamp
    end
        
    def load_timestamp
      @timestamp = nil
      if File.exist?(@timestamp_file)
        File.open(@timestamp_file, "r") { |f| @timestamp = DateTime.parse f.read }
      end
    end
        
    def fetch_feeds
      @items = Array.new
      @feeds.each_value do |feed|
        rss = TweeterssRss.new(feed['url'], @timestamp)
        rss.entries.each do |entry|
		      @items << [entry, '#' + feed['hash']]
        end
      end
    end
        
    def tweet_entries
      twitter = TweeterssTweet.new(@username, @password, @delay, @items)
    end
        
    def write_timestamp
      File.open(@timestamp_file, 'w') { |f| f.write DateTime.now }
    end
        
end
