class EventsController < ApplicationController

  def index
    @events = Event.paginate(
      :page => params[:page],
      :include => [ :lines, :location ],
      :conditions => [ "locations.status IN ('VALID','APPROXIMATE')" ],
      :order => "event_datetime DESC",
      :per_page => 10
    )

    respond_to do |format|
      format.xml { render :xml => (@events.to_xml :include => [:lines, :location]) }
      format.json { render :json => (@events.to_json :include => [:lines, :location]) }
      format.html {

        @map = GMap.new("map_div")
        @map.control_init(:large_map => true, :map_type => true)
        @map.icon_global_init(GIcon.new(:copy_base => GIcon::DEFAULT,
                               :icon_size => GSize.new(32,32),
                               :image => "/images/gicons/blue-dot.png",
                               :shadow => "/images/gicons/msmarker.shadow.png",
                               :shadow_size => GSize.new(59,32)),"blue_icon")
        @map.icon_global_init(GIcon.new(:copy_base => GIcon::DEFAULT,
                               :icon_size => GSize.new(32,32),
                               :image => "/images/gicons/green-dot.png",
                               :shadow => "/images/gicons/msmarker.shadow.png",
                               :shadow_size => GSize.new(59,32)),"green_icon")

        @blue_icon = Variable.new("blue_icon")
        @green_icon = Variable.new("green_icon")
                            
        @map.center_zoom_init([38.0378, -78.4893], 10)
        @events.each do |event|
          marker_content = render_to_string :partial => "event_marker",
                                            :object => event
          @map.overlay_init(
            GMarker.new([event.location.latitude,event.location.longitude],
              :info_window => marker_content,
              :title => event.lines[0].call_type,
              :icon =>
                (event.location.status == "VALID" ? @green_icon : @blue_icon)
          ))
        end
      }
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
