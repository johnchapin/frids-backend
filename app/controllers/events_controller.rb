class EventsController < ApplicationController

  def index
    @events = Event.paginate( 
      :page => params[:page],
      :include => [ :lines ],
      :order => "event_date DESC, event_time DESC")
  end

  def all
    @events = Event.find(:all, 
      :include => [ :lines ],
      :order => "event_date DESC, event_time DESC")
    respond_to do |format|
      format.html
      format.xml { render :xml => (@events.to_xml :include => :lines ) }
      format.json { render :json => (@events.to_json :include => :lines) }
    end
  end

  def show
    @event = Event.find(params[:id])
    @lines = Line.find_all_by_event_id(@event.id)
  end

end
