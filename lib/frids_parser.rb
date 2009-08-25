class FridsParser

  attr_accessor :line_type, :data_url

  def initialize(line_type, data_url)
    @line_type = line_type
    @data_url = data_url
    @logger = Logger.new(STDOUT)
  end

  def parse_data
    # Must be overridden
  end

  def process (skip_update = false)
    @result = self.parse_data
    @result.to_hash.each { |single_hash|
      single_hash["line_type"] = @line_type
#      @logger.info "Inserting or updating line: #{single_hash.to_s}"
      begin
        @line = Line.create_or_update(skip_update, single_hash)
      rescue ActiveRecord::StatementInvalid
        # This gets thrown on dupe inserts
        @logger.error "Error inserting or updating line: #{single_hash.to_s}"
      end
    }
  end

end
