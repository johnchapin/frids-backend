class EventsController < ApplicationController
  helper_method :render_to_string

  def index

   logger.info("JSC: #{params[:time_min]}")
   logger.info("JSC: #{params[:time_max]}")

    @time_min = Time.parse(params[:time_min] || (Time.new - 1.week).to_s)
    @time_max = Time.parse(params[:time_max] || Time.new.to_s)

   logger.info("JSC: #{@time_min}")
   logger.info("JSC: #{@time_max}")

    # The following SQL pseudo-code is for a point and a circular range
    # around that point.  This is nice, but very slow.
    #
    # SELECT id, place_name,
    # ROUND(
    #   SQRT(
    #     POW((69.1 * (#Val(arguments.latitude)# - latitude)), 2) +
    #     POW((53 * (#Val(arguments.longitude)# - longitude)), 2)
    #   ), 1) AS distance
    # FROM places
    # ORDER BY distance ASC
    #
    # Instead, we're just doing a box, defined by four values

    draw_limits = [:lat_min,:lat_max,:lon_min,:lon_max].any? {|p| params.key?(p)}

    # The ActiveRecord range ".." doesn't care if you give it String or
    # Float, but don't mix the two...

    lat_min = (params[:lat_min] || Location::LAT_MIN).to_f
    lat_max = (params[:lat_max] || Location::LAT_MAX).to_f
    lon_min = (params[:lon_min] || Location::LON_MIN).to_f
    lon_max = (params[:lon_max] || Location::LON_MAX).to_f

    lat_center = (lat_min+lat_max)/2.0
    lon_center = (lon_min+lon_max)/2.0

    @events = Event.paginate(
      :page => params[:page],
      :include => [ :lines, :location ],
      :conditions => { "locations.status" => ["VALID","APPROXIMATE"],
                       "locations.latitude" => lat_min..lat_max,
                       "locations.longitude" => lon_min..lon_max,
                       "lines.call_received" => @time_min.getutc..@time_max.getutc},
      :order => "event_datetime DESC",
      :per_page => 10
    )

    respond_to do |format|
      format.xml { render :xml => (@events.to_xml :include => [:lines, :location]) }
      format.json { render :json => (@events.to_json :include => [:lines, :location]) }
      format.js {
        render :update do |page|
          page.replace_html 'events_div', :partial => 'events_list'
          @map = Variable.new("map")
        end
      }

      format.html {

        @map = GMap.new("map_div")
        @map.record_init("map.addControl(dragZoom = new DragZoomControl(), new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(7,7)));")
                  
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

        if (draw_limits)
          @map.overlay_init(GPolygon.new([[90,-180],[90,lon_min],[0,lon_min],[0,-180],[90,-180]],"#000000",0.0,0.0,"#ff0000",0.075,0.1))
          @map.overlay_init(GPolygon.new([[90,lon_max],[90,0],[0,0],[0,lon_max],[90,lon_max]],"#000000",0.0,0.0,"#ff0000",0.075,0.1))
          @map.overlay_init(GPolygon.new([[90,lon_min],[90,lon_max],[lat_max,lon_max],[lat_max,lon_min],[90,lon_min]],"#000000",0.0,0.0,"#ff0000",0.075,0.1))
          @map.overlay_init(GPolygon.new([[lat_min,lon_min],[lat_min,lon_max],[0,lon_max],[0,lon_min],[lat_min,lon_min]],"#000000",0.0,0.0,"#ff0000",0.075,0.1))
          @map.overlay_init(GPolygon.new([[lat_min,lon_min],[lat_min,lon_max],[lat_max,lon_max],[lat_max,lon_min],[lat_min,lon_min]],"#000000",0.5,1.0,"#000000",0.0,1.0))
        end

                            
        if (draw_limits)
          # bounds_init gave very strange results, but this works ok
          @map.center_zoom_on_points_init([lat_min, lon_max],[lat_max,lon_min])
        else
          @map.center_zoom_init([lat_center,lon_center],10)
        end
        
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
