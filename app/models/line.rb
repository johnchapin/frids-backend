class Line < ActiveRecord::Base
  has_one :event

  def Line.create_or_update(args)
    skip_update = args.delete(:skip_update) || false
    line_args = args.delete(:line_args)

    line = skip_update ? nil : Line.first(:conditions => {
                                :line_date => Date.parse(line_args[:line_date]),
                                :incident_number => line_args[:incident_number],
                                :unit => line_args[:unit]})

    if line.nil?
      line = Line.new(line_args)
    end

    line.fix_call_received_time
    line.fix_arrived_on_scene_time
    line.process_event
    line.save
    line
  end

  def fix_call_received_time
    if !self.call_received.nil? &&
       !self.line_date.nil?
      self.call_received = Time.local(self.line_date.year, self.line_date.month, self.line_date.day, self.call_received.hour, self.call_received.min, self.call_received.sec)
    end
  end

  def fix_arrived_on_scene_time
    if !self.arrived_on_scene.nil? &&
       !self.call_received.nil?
      self.arrived_on_scene = Time.local(self.line_date.year, self.line_date.month, self.line_date.day, self.arrived_on_scene.hour, self.arrived_on_scene.min, self.arrived_on_scene.sec)
      0.upto(10) do
        break if self.arrived_on_scene > self.call_received
          self.arrived_on_scene += 1.day
      end  
    end
  end

  def get_response_time
    if !self.arrived_on_scene.nil? &&
       !self.call_received.nil?
      self.arrived_on_scene - self.call_received
    end
  end

  def process_event
    window_begin = self.call_received - 15.minutes
    window_end = self.call_received + 15.minutes
    response_time = get_response_time
    
    event = self.event_id.nil? ? Event.find(:first,
                         :conditions => {
                         :event_datetime => window_begin..window_end,
                         :address => self.address }) : Event.find(self.event_id)
                        

    if event.nil?
      event = Event.create(
                :event_datetime => self.call_received,
                :address => self.address,
                :tax_map => self.tax_map,
                :response_time => response_time )
      if event.event_datetime > Time.new - 1.hour
        Delayed::Job.enqueue(Tweet.new(self.call_type, event.address, event.id))
      end
    else
      if !response_time.nil?
        if !event.response_time.nil?
          event.response_time = [event.response_time, response_time].min
        else
          event.response_time = response_time
        end
        event.save
      end
    end
    self.event_id = event.id
  end

end
