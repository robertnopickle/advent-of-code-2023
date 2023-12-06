# frozen_string_literal: true

input = File.read(ENV.fetch('input')).split("\n\n")

seeds = input[0].split(' ').drop(1).map(&:to_i)
map_input = input.drop 1

maps = map_input.map do |map|
  split_map = map.split("\n")
  source_name, destination_name = split_map[0].split(' ').first.split('-to-')
  result = { source: source_name, destination: destination_name, source_to_destination_ranges: [] }
  split_map.drop(1).each do |line|
    destination_range_start, source_range_start, range_length = line.split(' ').map(&:to_i)
    result[:source_to_destination_ranges] << {
      destination_range_start: destination_range_start,
      source_range_start: source_range_start,
      range_length: range_length
    }
  end
  result
end

locations_by_seed = []

seeds.each do |seed|
  previous_value = seed
  source = "seed"
  destination = ""
  destination_value = nil

  until source == "location"
    map = maps.find { |m| m[:source] == source }
    destination = map[:destination]
    found = false
    map[:source_to_destination_ranges].each do |range|
      if range[:source_range_start] <= previous_value && range[:source_range_start] + range[:range_length] >= previous_value
        destination_value = range[:destination_range_start] + (previous_value - range[:source_range_start])
        source = destination
        previous_value = destination_value
        found = true
        break
      end
    end

    next if found

    destination_value = previous_value
    source = destination
  end

  locations_by_seed << { seed: seed, location: destination_value }
end

puts locations_by_seed.sort_by { |lbs| lbs[:location] }.first[:location]
