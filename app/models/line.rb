class Line < ActiveRecord::Base
  before_create :process_event
  has_one :event

  private

    def process_event

      self.call_received = Time.utc(self.line_date.year,
                                     self.line_date.month,
                                     self.line_date.day,
                                     self.call_received.hour,
                                     self.call_received.min,
                                     self.call_received.sec)

      @window_begin = self.call_received - 15.minutes
      @window_end = self.call_received + 15.minutes

      @event = Event.find(:first,
        :conditions => { :event_datetime => @window_begin..@window_end,
                         :address => self.address })

      if (@event.nil?)
        @event = Event.create(
            :event_datetime => self.call_received,
            :address => self.address,
            :tax_map => self.tax_map
          )
      end
      self.event_id = @event.id
    end

end
