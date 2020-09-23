require_relative 'main'

url = ARGV[0]
file = ARGV[1]

puts 'Start parsing'
Main.new.start(url, file)
puts 'Parsing ended'

