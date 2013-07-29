require 'crocodoc'

class DocumentsController < ApplicationController

include Crocodoc
    
  before_filter :authenticate_user!
  
  
  # GET /documents
  # GET /documents.json
  def index
    @documents = Document.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @documents }
    end
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    @document = Document.find(params[:id])
    
    @session = create_session(@document.uuid, :downloadable => true)[:session]
    @embeddable_url = session_viewer_url(session)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @document }
    end
  end

  # GET /documents/new
  # GET /documents/new.json
  def new
    @document = Document.new
 
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @document }
    end
  end

  # GET /documents/1/edit
  def edit
    @document = Document.find(params[:id])
  end

  # POST /documents
  # POST /documents.json
  def create

    @document = Document.new(params[:document])
    @document.user = current_user
    
    # Upload the document to Crocodoc and get the UUID 
    
    # Get the path for the temporary file and add the appropriate extension
    tmp_file_path = params[:attachment].path
    file_extension = params[:attachment].original_filename.scan(/\.\w+$/)[0]
    File.rename(tmp_file_path, tmp_file_path + file_extension)
    tmp_file_path += file_extension
    
    # Read the file
    attachment = File.new(tmp_file_path, "r")
    
    # Upload the file to Crocodoc
    uuid = upload(attachment)[:uuid]
    
    logger.debug "UUID returned is #{uuid}" 
    
    @document.uuid = uuid   
	
	# Tag List
	
  	taglist = JSON.parse(params[:tags])
  	logger.debug "Taglist: #{taglist}"
  	taglist.each do |tagname|
  		tag = (Tag.where(:name => tagname).exists?) ? Tag.where(:name => tagname) : Tag.new(:name => tagname)
  		@document.tags << tag
  		logger.debug "Assigning tag '#{tagname}' to document (#{@document.id})"
  	end
  	
    respond_to do |format|
      if @document.save
        format.html { redirect_to @document, :notice => "" }
        format.json { render :json => @document, :status => :created, :location => @document }
      else
        format.html { render :action => "new" }
        format.json { render :json => @document.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /documents/1
  # PUT /documents/1.json
  def update
    @document = Document.find(params[:id])

    respond_to do |format|
      if @document.update_attributes(params[:document])
        format.html { redirect_to @document, :notice => 'Document was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @document.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document = Document.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to documents_url }
      format.json { head :no_content }
    end
  end
end
