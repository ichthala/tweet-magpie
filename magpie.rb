class Magpie

  attr_accessor :max_id
  attr_reader :client

  def initialize(client, username)
    client = client
    @username = username
    @tweetfile = File.new("tweets.txt", 'a+')
  end

  def go
    if first_retrieval = true
      get_all_tweets
    else
      get_new_tweets
    end
  end

  def get_all_tweets
    max_id = client.user_timeline(@username, include_rts: false, count: 1)[0].id

    while tweets = get_page_of_tweets
      all_tweets.push *tweets
    end

    @tweets = all_tweets.reverse!

    write_to_file

    puts "All tweets successfully written to tweets.txt!"
  end

  def get_page_of_tweets
    begin
      tweets = client.user_timeline(@username, max_id: max_id, include_rts: false, count: 200)
    rescue Twitter::Error::TooManyRequests
      puts 'Your rate limit was exceeded. Could not retrieve all tweets. Please try again later.'
      exit
    end

    max_id = tweets[-1]
    tweets == [] ? false : tweets
  end

  def get_new_tweets
  end

  def write_to_file
    @tweets.each do |tweet|
      str = "#{tweet.id} | #{tweet.created_at} | #{tweet.text.length} chars\n" +
        "#{tweet.text}\n\n"

      if reply_to_id = tweet.in_reply_to_status_id
        reply_to_tweet = client.status(reply_to_id)
        str << "\tIn reply to:\n" +
          "\t#{reply_to_tweet.id} | #{reply_to_tweet.created_at}" +
          "\t#{reply_to_tweet.user.screen_name} (#{reply_to_tweet.user.name})\n" +
          "\t#{reply_to_tweet.text}\n\n"
      end

      puts "Writing to file:\n#{str}"
      @tweetfile << str
    end

    @tweetfile.close
  end

end