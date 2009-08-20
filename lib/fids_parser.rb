#!/usr/bin/env ruby

require 'rubygems'
require 'scrubyt'

class FidsParser < FridsParser
  def parse_data
    @@fids_data_url = @data_url
    Scrubyt::Extractor.define do
	    fetch @@fids_data_url
      record "/html/body/center/table/tr/td/table/tr" do
	  	  line_date "/td[1]/font"
		    incident_number "/td[2]/font"
		    unit "/td[3]/font"
  		  address "/td[4]/font"
	  	  tax_map "/td[5]/font"
		    call_type "/td[6]/font"
		    call_received "/td[7]/font"
  		  call_dispatch "/td[8]/font"
	  	  unit_enroute "/td[9]/font"
		    arrived_on_scene "/td[11]/font"
		    in_service "/td[14]/font"
		    url "/td[3]/font/b/a/@href"
	    end.ensure_presence_of_pattern('incident_number')
    end
  end
end
