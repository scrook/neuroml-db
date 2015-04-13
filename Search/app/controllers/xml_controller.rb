require 'nokogiri'

class XmlController < ApplicationController
  caches_action :robots

  # Takes modelID as parameter and gets its NeuroML file, rendering it
  def render_xml_file
    render :text => File.read(Model.GetFile(params[:modelID].to_s)), :content_type => 'application/xml'
  end

  # Takes ModelID as parameter, gets its NeuroML, transforms it with XSL, and displays result
  def render_xml_as_html

    # Get the model XML file
    modelFile = Model.GetFile(params[:modelID].to_s)

    # Execute python script that transforms the model's NeuroML to HTML
    result = `/usr/bin/python /var/www/NeuroMLXSL/main.py #{modelFile}`

    # Display HTML
    render :text => result

  end

end
