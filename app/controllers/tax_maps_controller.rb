class TaxMapsController < ApplicationController

  def index
    @tax_maps = TaxMap.paginate(
      :page => params[:page],
      :order => "tax_map_number ASC")
    respond_to do |format|
      format.html
     format.xml { render :xml => @tax_maps.to_xml }
     format.json { render :json => @tax_maps.to_json }
   end
  end

  def show
   @tax_map = TaxMap.find(params[:id])
   respond_to do |format|
     format.html
     format.xml { render :xml => @tax_map.to_xml }
     format.json { render :json => @tax_map.to_json }
  end
  end

end
