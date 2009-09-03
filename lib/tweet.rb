class Tweet

  def initialize (event_type, event_address, event_id)
    @event_type,@event_address,@event_id = event_type,event_address,event_id
    httpauth = Twitter::HTTPAuth.new('RIDSWatcher', '')
    @base = Twitter::Base.new(httpauth)
  end

  def perform
    event_url = shorten_url("http://www.cvillemaps.com/events/#{@event_id}")
    tweet="\"#{@event_type.titleize}\" at #{@event_address.titleize} #{event_url}"
    # @base.update(@tweet) unless @base.nil?
    print "TWEET: #{tweet}\n"
  end

  private

  def shorten_url (url)
    open("http://tinyurl.com/api-create.php?url=#{url}").read
  end


end
