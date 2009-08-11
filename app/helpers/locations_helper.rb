module LocationsHelper
  
  @@key_regex = Regexp.compile("[^A-Za-z0-9]")
  @@removal_regexes = [ Regexp.compile("\\- *[UVA|BLDG|AP|CP|STE]"),
                        Regexp.compile("\\-$"),
                        Regexp.compile("^ +"),
                        Regexp.compile(" +$"),
                        Regexp.compile("\\(.*\\)") ]
  @@space_regex = Regexp.compile("[\\s]+")

  def self.createKey(in_string)
    in_string.gsub(@@key_regex,"").upcase
  end

  def self.cleanAddress(in_address)
    @@removal_regexes.each { |regex| in_address.gsub(regex,"") }
    in_address.gsub("&"," & ").gsub(@@space_regex," ")
  end

end
