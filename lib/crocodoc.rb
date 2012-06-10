require 'rest-client'
require 'json'

module Crocodoc
  extend self

  # Crocodoc's API's base URL
  API_URL = "https://crocodoc.com/api/v2"

  # These options are your preferred defaults that will be passed to various
  # API methods, so that you don't have to pass the same things in each time.
  # Any of these options can be overridden when calling an API method by
  # simply passing the option to the method with a different value.
  API_OPTIONS = {
    # Your API token
    :token => "nbgCH9O6u0tPwq1sSAdFNVY3",

    # When uploading in async mode, a response is returned before conversion begins.
    :async => false,

    # Documents uploaded as private can only be accessed by owners or via sessions.
    :private => false,

    # When downloading, should the document include annotations?
    :annotated => false,

    # Can users mark up the document? (Affects both #share and #get_session)
    :editable => false,

    # Whether or not a session user can download the document.
    :downloadable => false
  }

  # "Upload and convert a file. This method will try to convert a file that has
  #  been referenced by a URL or has been uploaded via a POST request."
  def upload(url_or_file, options = {})
  
  	Rails.logger.debug "upload method"
  	
  	parameters = {}
    
    parameters[:token] = API_OPTIONS[:token]
    
    if url_or_file.is_a? String
    	parameters[:url] = url_or_file
    else
    	parameters[:file] = url_or_file
    end
    
    _request("/document/upload", :post, parameters)
  end

  # "Check the conversion status of a document."
  def status(*uuids)
    options = {}
    options.merge! uuids.pop if uuids.last.is_a? Hash
    options.merge! :uuids => uuids.join(",")
    _shake_and_stir_params(options, :uuids, :token)

    _request("/document/status", :get, options)
  end

  # "Delete an uploaded file."
  def delete(uuid, options = {})
    options.merge! :uuid => uuid
    _shake_and_stir_params(options, :uuid, :token)

    _request("/document/delete", :get, options)
  end

  # "Download an uploaded file with or without annotations."
  def download(uuid, options = {})
    options.merge! :uuid => uuid
    _shake_and_stir_params(options, :uuid, :annotated, :token)

    _request_raw("/document/download", :get, options)
  end

  # "Creates a new 'short ID' that can be used to share a document."
  def share(uuid, options = {})
    options.merge! :uuid => uuid
    _shake_and_stir_params(options, :uuid, :editable, :token)

    _request("/document/share", :get, options)
  end

  # "Clones an uploaded document. Document annotations are not copied."
  def clone(uuid, options = {})
    options.merge! :uuid => uuid
    _shake_and_stir_params(options, :uuid, :token)
    
    _request("/document/clone", :get, options)
  end

  # "Creates a session ID for session-based document viewing. Each session ID
  #  may only be used once."
  
  # Required Parameters:
  #		uuid => [String]
  
  # Optional Parameters:
  #		:user => {:name => "[User name to show in viewer]", :id => "[32-bit unique integer]"}
  #		:editable => [Boolean, Default: false]
  #		:filter => "[Either 'all', 'none', or User IDs separated by commas]"
  #		:admin => [Boolean, Default: false]
  #		:downloadable => [Boolean, Default: false]
  #		:copyprotected => [Boolean, Default: false]
  #		:demo => [Boolean, Default: false]
  
  def create_session(uuid, options = {})
    
    parameters = {}
    
    # token & user (required)
    parameters[:token] = API_OPTIONS[:token]
    parameters[:uuid] = uuid
   	
   	# user
    if options[:user] then
    	parameters[:user] = "#{options[:user][:id]},#{options[:user][:name]}"
    end
    
    # editable
    if options[:editable] then
    	if options[:user] then
    		parameters[:editable] = true
    	else
    		raise ArgumentError, "The 'user' parameter must be specified if 'editable' is true."
    	end
    end
    
   # downloadable
   if options[:downloadable] == true then
   		parameters[:downloadable] = true
   end
   
   logger.debug("create_session: parameters: #{parameters}")
   
   # implement other options here
 	
 	_request("/session/create", :post, parameters)
  end

  # "Obtain the URL to the document viewer to embed in an <iframe>."
  def session_viewer_url(session)
    "https://crocodoc.com/view/#{session}"
  end

  private

  def _request(path, method, options)
  	
  	    response_body = _request_raw(path, method, options)

    if response_body == false
      false
    elseif response_body == "true"
      # JSON.parse has a problem with parsing the string "true"...
      true
    else
      JSON.parse(response_body, :symbolize_names => true)
    end
  end

  def _request_raw(path, method, options)
    response = case method
	when :get
     	RestClient.get(API_URL + path, :params => options)
	when :post
  		RestClient.post(API_URL + path, options)
	else
  		raise ArgumentError, "method must be :get or :post"
    end
    
    response.code == 200 ? response.to_str : false
  end

  def _shake_and_stir_params(params, *whitelist)
    # Mix and stir the two params hashes together.
    params.replace API_OPTIONS.merge(params)

    # Shake out the unwanted params.
    params.keys.each do |key|
      params.delete(key) unless whitelist.include? key
    end
  end
end
