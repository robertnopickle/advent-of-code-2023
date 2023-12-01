# frozen_string_literal: true

MODES = {
  'LATEST_WITH_TEST=1' => :latest_test,
  'LATEST_WITH_SAMPLE=1' => :latest_sample,
  'SPECIFIC=1' => :specific
}.freeze

mode = MODES[ARGV.first] || :latest_test # default to latest test

day_num = ARGV[1] # day number
part_letter = ARGV[2] # part letter
input_source = ARGV[3] # input source

day =
  if mode == :specific && !day_num.nil?
    Dir.glob("day#{day_num.to_s.rjust(2, '0')}").max
  else
    Dir.glob('day*').max
  end

part =
  if mode == :specific && !part_letter.nil?
    Dir.glob("#{day}/#{part_letter}.rb").max
  else
    Dir.glob("#{day}/*.rb").max
  end

input =
  if mode == :specific && !input_source.nil?
    Dir.glob("#{day}/#{input_source}.txt").max
  elsif mode == :latest_sample
    Dir.glob("#{day}/sample.txt").max
  else
    Dir.glob("#{day}/test.txt").max
  end

# hand any nil values with a message and exit
if [day, part, input].any?(&:nil?)
  puts 'Something went wrong!'
  exit
end

ENV['input'] = input
puts "==================================\n\n"
puts "Running #{part} with #{input}...\n\n"
puts 'answer:'
starting = Time.now
require "./#{part}"
ending = Time.now
puts "\n\n"
puts "elapsed time: #{ending - starting} seconds"
puts
puts '=================================='
