class ApplicationController < ActionController::Base
  protect_from_forgery
    def index
      @documents = Document.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render :json => @documents }
      end
    end
  
end
