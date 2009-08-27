namespace :frids do

  task :default => [:ingest, :geocode]

  task (:ingest => :environment) do
    RidsParser.process ("http://warhammer.mcc.virginia.edu/rids/rids.php")
    FidsParser.process("http://warhammer.mcc.virginia.edu/fids/fids.php")
  end

  task :ingest_files => [:ingest_rids_files,:ingest_fids_files]

  task (:ingest_rids_files => :environment) do
    Find.find( File.join( File.dirname(__FILE__), "../../files/rids_downloads")) do |path|
      if (File.file?(path))
        rids_parser = RidsParser.new("rids", path)
        rids_parser.process(true)
      end
    end
  end

  task (:ingest_fids_files => :environment) do
    Find.find( File.join( File.dirname(__FILE__), "../../files/fids_downloads")) do |path|
      if (File.file?(path))
        fids_parser = RidsParser.new("fids", path)
        fids_parser.process(true)
      end
    end
  end

  task (:requeue_failed_locations => :environment) do
    locations = Location.all( :conditions => {:status => "FAILED"})
    locations.each { |location| Delayed::Job.enqueue(location) }
  end

  task (:ping_google_maps_api => :environment) do
    result = GeocodeUtils.ping
    print "Google Maps API response code: #{result} : #{GeocodeUtils::STATUS_MESSAGES[result]}\n"
  end

end
