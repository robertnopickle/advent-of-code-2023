# frozen_string_literal: true

lines = File.read(ENV.fetch('input')).split("\n")

VALID_NUMBER_WORDS = {
  one: '1',
  two: '2',
  three: '3',
  four: '4',
  five: '5',
  six: '6',
  seven: '7',
  eight: '8',
  nine: '9'
}.freeze

line_numbers = []

lines.each do |line|
  regex = Regexp.new "(?=(#{VALID_NUMBER_WORDS.keys.join('|')}|\\d))"
  digits = line.scan(regex).flatten.map { |x| VALID_NUMBER_WORDS.fetch(x.to_sym, x) }
  number = digits.values_at(0, -1).reduce { |a, b| a + b }.to_i
  line_numbers << number
end

puts line_numbers.sum
