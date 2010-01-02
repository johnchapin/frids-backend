class EventsController < ApplicationController
  helper_method :render_to_string

  def index

    @time_min = Time.parse(params[:time_min] || (Time.new - 1.week).to_s)
    @time_max = Time.parse(params[:time_max] || Time.new.to_s)

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

    per_page = params[:per_page] || 10;

    # Have to reference these classes before using Rails.cache, otherwise
    # the unmarshalling will bomb with "undefined class" errors
    Event
    Line
    @events = Rails.cache.fetch(params.to_s, :expires_in => 2.minutes) {
      Event.paginate(
        :page => params[:page],
        :include => [ :lines, :location ],
        :conditions => { "locations.status" => ["VALID","APPROXIMATE"],
                         "locations.latitude" => lat_min..lat_max,
                         "locations.longitude" => lon_min..lon_max,
                         "lines.call_received" => @time_min.getutc..@time_max.getutc},
        :order => "event_datetime DESC",
        :per_page => per_page
      )
    }

    # if ( Rails.cache.fetch()) {
    # }


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
        @map = get_gmap("map_div", draw_limits, lat_min, lat_max, lon_min, lon_max)
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
