DIR = File.dirname(__FILE__)

require "#{DIR}/parser.rb"
@parser = Parser.new

files = Dir[DIR+'/*.xml']

files.each do |file|
  name = file.slice(/\.\/\w+\./).slice(/\w+/)
  html_file = File.new("#{name}.html", "w+")
  @parser.load("#{DIR}/#{name}.xml")
  html_string = @parser.replace_all
  html_file.write html_string
  puts 'Done!'
end
