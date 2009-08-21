class Line < ActiveRecord::Base
  before_create :process_event
  has_one :event

  private

    def process_event

      self.call_received = Time.local(self.line_date.year,
                                     self.line_date.month,
                                     self.line_date.day,
                                     self.call_received.hour,
                                     self.call_received.min,
                                     self.call_received.sec)

      if ! self.arrived_on_scene.nil?
        self.arrived_on_scene = Time.local(self.line_date.year,
                                     self.line_date.month,
                                     self.line_date.day,
                                     self.arrived_on_scene.hour,
                                     self.arrived_on_scene.min,
                                     self.arrived_on_scene.sec)
      end

      @window_begin = self.call_received - 15.minutes
      @window_end = self.call_received + 15.minutes

      @event = Event.find(:first,
        :conditions => { :event_datetime => @window_begin..@window_end,
                         :address => self.address })

      response_time_seconds = nil
      if (@event.nil?)
        if ! self.arrived_on_scene.nil?
          response_time_seconds =
            self.arrived_on_scene - self.call_received
        end
        @event = Event.create(
            :event_datetime => self.call_received,
            :address => self.address,
            :tax_map => self.tax_map,
            :response_time => response_time_seconds
          )
      else
        if ! self.arrived_on_scene.nil?
          response_time_seconds =
            self.arrived_on_scene - @event.event_datetime
          if @event.response_time.nil? ||
             @event.response_time > response_time_seconds
            @event.response_time = response_time_seconds
            @event.save
          end
        end
      end
      self.event_id = @event.id
    end

end
