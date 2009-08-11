class LocationsController < ApplicationController

  def index
    @locations = Location.paginate( 
      :page => params[:page],
      :order => "updated_at DESC")
    respond_to do |format|
      format.html
      format.xml { render :xml => @locations.to_xml }
      format.json { render :json => @locations.to_json }
    end
  end

  def show
    @location = Location.find(params[:id])
    respond_to do |format|
      format.html
      format.xml { render :xml => @location.to_xml }
      format.json { render :json => @location.to_json }
    end
  end

end
