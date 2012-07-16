libdir = File.expand_path(File.dirname(__FILE__))
$:.unshift(libdir) unless $:.include?(libdir)

# Require all of the Ruby files in the given directory.
#
# path - The String relative path from here to the directory.
#
# Returns nothing.
def require_all(path)
  glob = File.join(File.dirname(__FILE__), path, '*.rb')
  Dir[glob].each do |f|
    require f
  end
end

module Obtions
  VERSION = '0.1'
  ROOTDIR = File.expand_path("#{File.dirname(__FILE__)}/..")
  SPECDIR = "#{ROOTDIR}/spec"
  DATADIR = "#{SPECDIR}/data"
end

require     'date'
require     'ostruct'
require     'optparse'
require_all 'obtions'
require_all 'obtions/elements'
