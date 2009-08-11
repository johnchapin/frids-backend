class EventsController < ApplicationController

  def index
    @events = Event.paginate( 
      :page => params[:page],
      :include => [ :lines, :location ],
      :order => "event_datetime DESC",
      :per_page => 10
    )

    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init([38.0378, -78.4893], 10)
    @events.each do |event|
      @map.overlay_init(
        GMarker.new([event.location.latitude,event.location.longitude],
          :info_window => "<table><tr><th><b>Address:</b></th><td>#{event.location.clean_address}</td></tr><tr><th><b>Incident:</b></th><td>#{event.lines.collect{|l|l.call_type}.uniq.join("<br/>")}</td></tr><tr><th><b>Units:</b></th><td>#{event.lines.collect{|l|l.unit + (l.arrived_on_scene.nil? ? ", no arrival time available" : ", arrived " + l.arrived_on_scene.strftime("%H:%M:%S %D"))}.join("<br/>")}</td></tr></table>"
        ))
    end
    respond_to do |format|
      format.html
      format.xml { render :xml => (@events.to_xml :include => [ :lines, :location] ) }
      format.json { render :json => (@events.to_json :include => [ :lines, :location] ) }
    end
  end

  def show
    @event = Event.find(params[:id], :include => [:lines, :location])
    respond_to do |format|
      format.html
      format.xml { render :xml => (@event.to_xml :include => [:lines, :location] ) }
      format.json { render :json => (@event.to_json :include => [:lines, :location]) }
    end
  end

end
