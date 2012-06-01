DIR = File.dirname(__FILE__)

require "#{DIR}/parser.rb"
@parser = Parser.new

pml_files = Dir[DIR+'/*.pml']
xml_files = Dir[DIR+'/*.xml']

pml_files.each do |file|
  file.slice!("#{DIR}/")
  file.slice!(/\.\S+/)
  File.rename("#{file}.pml", "#{file}.xml")  
  html_file = File.new("html/#{file}.html", "w+")
  puts "parsing #{file}"
  @parser.load("#{DIR}/#{file}.xml")
  html_string = @parser.replace_all
  html_file.write html_string
  puts "#{file} was converted"
end

xml_files.each do |file|
  file.slice!("#{DIR}/")
  file.slice!(/\.\S+/)
  html_file = File.new("html/#{file}.html", "w+")
  puts "parsing #{file}"
  @parser.load("#{DIR}/#{file}.xml")
  html_string = @parser.replace_all
  html_file.write html_string
  puts "#{file} was converted"
end

puts "----Done!----"