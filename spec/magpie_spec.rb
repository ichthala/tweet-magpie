require 'spec_helper'
require 'twitter'

describe Magpie do
  let(:five_tweets) { [double(id: 6), double(id: 5), double(id: 4), double(id: 3), double(id: 2)] }
  let(:username) { 'ichthala' }
  let(:client) { double('twitter') }

  describe '#get_page_of_tweets' do
    before(:each) do
      @magpie = Magpie.new(client, username)
      @client = @magpie.client
    end

    context 'when no Twitter errors are encountered' do
      before(:each) do
        @client.stub(:user_timeline)
          .with(username, include_rts: false, count: 1)
          .and_return(five_tweets[0])
      end

      # xxx too bloated must refac
      it 'pages through a user\'s tweets' do
        @client.should_receive(:user_timeline)
          .with(username, max_id: 6, include_rts: false, count: 200)
          .and_return(five_tweets)

        @client.should_receive(:user_timeline)
          .with(username, max_id: 1, include_rts: false, count: 200)
          .and_return([])

        @magpie.max_id = 6
        @magpie.get_page_of_tweets

        expect(@magpie.max_id).to eq 2

        expect(@magpie.get_page_of_tweets).to eq false
      end
    end

    context 'when a Twitter error is encountered' do
      it 'exits gracefully' do
        @client.stub(:user_timeline).and_return(Twitter::Error::TooManyRequests)
        # xxx i don't like that i have to set max_id before testing
        @magpie.max_id = 1
        @magpie.get_page_of_tweets
        # i also don't like that there's no explicit expectation
      end
    end
  end

end