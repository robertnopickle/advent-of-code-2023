# frozen_string_literal: true

lines = File.read(ENV.fetch('input')).split("\n")

line_numbers = []

lines.each do |line|
  digits = line.tr('^0-9', '') # trim out all non-digits
  first_digit = digits[0]
  last_digit = digits[-1]

  # concat the first and last digit, and convert to integer
  number = "#{first_digit}#{last_digit}".to_i

  line_numbers << number
end

puts line_numbers.sum
