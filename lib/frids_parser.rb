class FridsParser

  attr_accessor :line_type, :data_url

  def initialize(line_type, data_url)
    @line_type = line_type
    @data_url = data_url
    #@log = Logger.new(STDOUT)
  end

  def parse_data
    # Must be overridden
  end

  def process
    @result = self.parse_data
    @result.to_hash.each { |single_hash|
      single_hash["line_type"] = @line_type
      begin
        @line = Line.create(single_hash)
      rescue ActiveRecord::StatementInvalid
        # This gets thrown on dupe inserts
        #@log.info("Caught ActiveRecord::StatementInvalid: " + $!)
      end
    }
  end

end
