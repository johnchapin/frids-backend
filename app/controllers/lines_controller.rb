class LinesController < ApplicationController

  def index
    @lines = Line.paginate(:page => params[:page], :order => "line_date DESC, call_received DESC")
    respond_to do |format|
      format.html
      format.xml { render :xml=>@lines }
      format.json { render :json=>@lines }
    end
  end

  def show
    @line = Line.find(params[:id])
    respond_to do |format|
      format.html
      format.xml { render :xml=>@line }
      format.json { render :json=>@line }
    end
  end

  def create
    @line = Line.create(params[:Line])
  end

end
