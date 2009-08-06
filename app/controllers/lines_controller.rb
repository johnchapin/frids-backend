class LinesController < ApplicationController

  def index
    @lines = Line.find(:all, :order => "line_date DESC, call_received DESC")
    respond_to do |format|
      format.html
      format.xml { render :xml=>@lines }
      format.json { render :json=>@lines }
    end
  end

  def show
    @line = Line.find(params[:id])
  end

  def create
    @line = Line.create(params[:Line])
    if (! @line.nil?)
      # We successfully created the line, so look for other lines that might
      # be part of the same event.  An event is a group of lines, which occur
      # at the same location, with no incident more than 15 minutes before or
      # after another incident in the same event.
      # TODO: This won't catch events that occur across date boundaries

      @window_begin = @line.call_received - 15.minutes
      @window_end = @line.call_received + 15.minutes

      @event = Event.find(:first,
        :conditions => { :event_date => @line.line_date,
                         :event_time => @window_begin..@window_end,
                         :location => @line.location })

      if (@event.nil?)
        logger.info("No existing event line - creating new Event")
        @event = Event.create(
            :event_date => @line.line_date,
            :event_time => @line.call_received,
            :location => @line.location,
            :tax_map => @line.tax_map
          )
        logger.info("New event id = #{@event.id}")
      else
        logger.info("Found existing event, event id = #{@event.id}")
      end
      @line.event_id = @event.id
      @line.save!
    end

  end

end
