libdir = File.expand_path(File.dirname(__FILE__) + '/../lib')
$:.unshift(libdir) unless $:.include?(libdir)

require 'obtions'

o = Obtions.parse! do
  flag :s, long: :silent do
    "Silence all logging output."
  end

  named_arg :logfile, type: File do
    "Specify location of log file."
  end

  arg :first do
    "First argument."
  end
end

puts o
