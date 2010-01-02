# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def get_gmap(div_name = "map_div", draw_limits = false, 
               lat_min = Location::LAT_MIN, lat_max = Location::LAT_MAX, 
               lon_min = Location::LON_MIN, lon_max = Location::LON_MAX)

	lat_center = (lat_min+lat_max)/2.0 
        lon_center = (lon_min+lon_max)/2.0  
 
        map = GMap.new("map_div") 
        map.record_init("map.addControl(dragZoom = new DragZoomControl(), new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(7,7)));") 
 
        map.control_init(:large_map => true, :map_type => true) 
        map.icon_global_init(GIcon.new(:copy_base => GIcon::DEFAULT, 
                               :icon_size => GSize.new(32,32), 
                               :image => "/images/gicons/blue-dot.png", 
                               :shadow => "/images/gicons/msmarker.shadow.png", 
                               :shadow_size => GSize.new(59,32)),"blue_icon") 
        map.icon_global_init(GIcon.new(:copy_base => GIcon::DEFAULT,
			       :icon_size => GSize.new(32,32),
                               :image => "/images/gicons/green-dot.png",
                               :shadow => "/images/gicons/msmarker.shadow.png",
                               :shadow_size => GSize.new(59,32)),"green_icon")
	if (draw_limits)
	  map.overlay_init(GPolygon.new([[90,-180],[90,lon_min],[0,lon_min],[0,-180],[90,-180]],"#000000",0.0,0.0,"#ff0000",0.075,0.1))
          map.overlay_init(GPolygon.new([[90,lon_max],[90,0],[0,0],[0,lon_max],[90,lon_max]],"#000000",0.0,0.0,"#ff0000",0.075,0.1)) 
          map.overlay_init(GPolygon.new([[90,lon_min],[90,lon_max],[lat_max,lon_max],[lat_max,lon_min],[90,lon_min]],"#000000",0.0,0.0,"#ff0000",0.075,0.1)) 
          map.overlay_init(GPolygon.new([[lat_min,lon_min],[lat_min,lon_max],[0,lon_max],[0,lon_min],[lat_min,lon_min]],"#000000",0.0,0.0,"#ff0000",0.075,0.1)) 
          map.overlay_init(GPolygon.new([[lat_min,lon_min],[lat_min,lon_max],[lat_max,lon_max],[lat_max,lon_min],[lat_min,lon_min]],"#000000",0.5,1.0,"#000000",0.0,1.0)) 
        end 
 
        if (draw_limits) 
          # bounds_init gave very strange results, but this works ok 
          map.center_zoom_on_points_init([lat_min, lon_max],[lat_max,lon_min]) 
        else 
          map.center_zoom_init([lat_center,lon_center],10) 
        end 
 
        map 
  end 

end
