class TagsController < ApplicationController

  # GET /documents
  # GET /documents.json
  def index
    @tags = Tag.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @tags }
    end
  end
  
  def show
  	@tag = Tag.find(params[:id])
  	
  	respond_to do |format|
  		format.html # show.html.erb
  		format.json { render :json => @tag }
  	end

end
