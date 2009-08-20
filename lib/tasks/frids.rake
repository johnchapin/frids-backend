namespace :frids do

  task :default => [:ingest, :geocode]

  task (:ingest => :environment) do
    rids_parser = RidsParser.new("rids", "http://warhammer.mcc.virginia.edu/rids/rids.php")
    rids_parser.process
    rids_parser = FidsParser.new("fids", "http://warhammer.mcc.virginia.edu/fids/fids.php")
    rids_parser.process
  end

  task (:geocode => :environment) do
    print "GEOCODE task called!\n"
  end

end
