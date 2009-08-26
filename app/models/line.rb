class Line < ActiveRecord::Base
  before_create :process_event
  has_one :event

  def self.create (options={})
    self.create_or_update(true,options)
  end

  def self.create_or_update (skip_update = false, options={})
    line = skip_update ? nil : Line.first(:conditions => {
                                  :line_date => Date.parse(options[:line_date]),
                                  :incident_number => options[:incident_number],
                                  :unit => options[:unit]})
    if line.nil?
      line = Line.new(options)
      line.call_received = add_date_to_time(line.line_date, line.call_received)
    else
      # This is the only reason for an update, at this point
      line.arrived_on_scene = options[:arrived_on_scene]
    end
    # Will get nil back if either arg is nil
    line.arrived_on_scene = add_date_to_time(line.line_date, line.arrived_on_scene)
    line.arrived_on_scene = fix_time_after_received(line.call_received,line.arrived_on_scene)
    line.save!
    line
  end

  private

    def self.fix_time_after_received(received_time, fix_time)
      if !received_time.nil? && !fix_time.nil?
        0.upto(10) do
          break if fix_time > received_time
          fix_time += 1.day
        end
      end
      fix_time
    end

    def self.add_date_to_time (in_date, in_time)
      if !in_date.nil? && !in_time.nil?
        Time.local(in_date.year, in_date.month, in_date.day, in_time.hour, in_time.min, in_time.sec)
      else
        nil
      end
    end

    def process_event

      @window_begin = self.call_received - 15.minutes
      @window_end = self.call_received + 15.minutes

      @event = Event.find(:first,
        :conditions => { :event_datetime => @window_begin..@window_end,
                         :address => self.address })

      response_time_seconds = nil
      if (@event.nil?)
        if ! self.arrived_on_scene.nil?
          response_time_seconds = self.arrived_on_scene - self.call_received
        end
        @event = Event.create(
            :event_datetime => self.call_received,
            :address => self.address,
            :tax_map => self.tax_map,
            :response_time => response_time_seconds
          )
      else
        if ! self.arrived_on_scene.nil?
          response_time_seconds = self.arrived_on_scene - @event.event_datetime
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
