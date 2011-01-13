require 'rubygems'
require 'twitter'

class TweeterssTweet
    
    def initialize(username, password, delay, entries)
        @twitter ||= Twitter::Base.new(username, password)
	      timestamp = Time.now
        while entries.length > 0
	        if timestamp + delay <= Time.now
        		e = entries.pop
	          tweet e[0], e[1]
            timestamp = Time.now
	        end
        end
    end
    
    private
        
      def tweet(msg, hash)
	      tweet = 'RT @' + msg + ' ' + hash
	      if msg.length > 140 - hash.length + 5
	    	  tweet = 'RT @' + msg[0, msg.length - hash.length + 5] + ' ' + hash
	      end
        @twitter.post('RT @' + msg[0, msg.length - hash.length + 5] + ' ' + hash)
      end
    
end
