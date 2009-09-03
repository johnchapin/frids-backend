class FridsParser

  def self.parse_data
    # Must be overridden
  end

  def self.process (url = nil, skip_update = false)
    @result = self.parse_data(url)
    @result.to_hash.each { |single_hash|
      single_hash["line_type"] = self.line_type
#      @logger.info "Inserting or updating line: #{single_hash.to_s}"
      begin
        @line = Line.create_or_update(:skip_update => skip_update, 
                                      :line_args => single_hash)
      rescue ActiveRecord::StatementInvalid
        # This gets thrown on dupe inserts
        @logger.error "Error inserting or updating line: #{single_hash.to_s}"
      end
    }
  end

end
