class TwitterAccount
  include HTTParty
  format :json
  base_uri 'twitter.com'
  attr_accessor :username, :password, :authorized

  def initialize(opts)
    @auth = {:username => opts[:user], :password => opts[:password]}

    begin
    self.class.get('http://twitter.com/account/verify_credentials.json', :basic_auth => @auth)
    @authorized = true
    rescue => e
      @authorized = false
    end
  end

  def post(text)
    options = { :query => {:status => text}, :basic_auth => @auth }
    self.class.post('/statuses/update.json', options)
  end

  def timeline(which = :friends, options = {})
    options.merge!({:basic_auth => @auth, :source => 'gutter'})
    twits = self.class.get("/statuses/#{which}_timeline.json", options)
    twits.inject([]) { |memo, twit| memo << Post.new(twit) }
  end
end