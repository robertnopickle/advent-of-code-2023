# frozen_string_literal: true

input_lines = File.read(ENV.fetch('input')).split("\n")
schematic = input_lines.map { |line| line.split('') }

sum = 0

def value_is_digit?(value)
  value.match?(/\d/)
end

def find_number_coords(schematic)
  number_coords = []
  schematic.each_with_index do |row, y|
    prev_was_digit = false
    row.each_with_index do |char, x|
      if value_is_digit?(char)
        next if prev_was_digit

        prev_was_digit = true
        number_coords << [x, y]
      else
        prev_was_digit = false
      end
    end
  end
  number_coords
end

def get_number(coords, schematic)
  x, y = coords
  digits = []

  while schematic[y][x]&.match?(/\d/)
    digits << schematic[y][x]
    x += 1
  end

  digits.join('').to_i
end

def get_x_range(x_coord, schematic, number_length)
  x_min = (x_coord - 1).negative? ? 0 : x_coord - 1
  x_max = x_coord + number_length > schematic[0].length - 1 ? schematic[0].length - 1 : x_coord + number_length
  (x_min..x_max)
end

def get_y_range(y_coord, schematic)
  y_min = (y_coord - 1).negative? ? 0 : y_coord - 1
  y_max = y_coord + 1 > schematic.length - 1 ? schematic.length - 1 : y_coord + 1
  (y_min..y_max)
end

def valid_part_number?(coords, number_length, schematic)
  x, y = coords
  y_range = get_y_range(y, schematic)
  x_range = get_x_range(x, schematic, number_length)

  y_range.each do |y_coord|
    x_range.each do |x_coord|
      value = schematic[y_coord][x_coord]
      return true if !value.match?(/\d/) && value != '.' && !value.nil?
    end
  end

  false
end

number_coords = find_number_coords(schematic)

number_coords.each do |coords|
  number = get_number(coords, schematic)
  number_length = number.to_s.length
  valid = valid_part_number?(coords, number_length, schematic)
  sum += number if valid
end

puts sum
