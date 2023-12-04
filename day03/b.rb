# frozen_string_literal: true

input_lines = File.read(ENV.fetch('input')).split("\n")
schematic = input_lines.map { |line| line.split('') }

def char_is_digit?(char)
  char.match?(/\d/)
end

# find all of the number coords and groupd them by their number in a has that includes the actual number
def find_numbers(schematic)
  numbers = []
  current_number = ''
  current_number_coords = []
  schematic.each_with_index do |row, y|
    prev_was_digit = false
    row.each_with_index do |char, x|
      if char_is_digit?(char)
        prev_was_digit = true
        current_number_coords << [x, y]
        current_number += char
      else
        if current_number_coords.any?
          number = { number: current_number.to_i, coords: current_number_coords }
          numbers << number
        end
        prev_was_digit = false
        current_number = ''
        current_number_coords = []
      end
    end
  end
  numbers
end

def char_is_gear?(char)
  char == '*'
end

def get_x_range(x_coord, schematic)
  x_min = (x_coord - 1).negative? ? 0 : x_coord - 1
  x_max = x_coord + 1 > schematic[0].length - 1 ? schematic[0].length - 1 : x_coord + 1
  (x_min..x_max)
end

def get_y_range(y_coord, schematic)
  y_min = (y_coord - 1).negative? ? 0 : y_coord - 1
  y_max = y_coord + 1 > schematic.length - 1 ? schematic.length - 1 : y_coord + 1
  (y_min..y_max)
end

def adjacent_gear_numbers(x_coord, y_coord, numbers, schematic)
  all_surrounding_coordinates = []
  x_range = get_x_range(x_coord, schematic)
  y_range = get_y_range(y_coord, schematic)

  x_range.each do |x|
    y_range.each do |y|
      all_surrounding_coordinates << [x, y]
    end
  end
  numbers.select { |number| (number[:coords] & all_surrounding_coordinates).any? }
end

def find_gear_products(numbers, schematic)
  gears = []
  gear_products = []
  schematic.each_with_index do |row, y|
    row.each_with_index do |char, x|
      next unless char_is_gear?(char)

      adjacent_numbers = adjacent_gear_numbers(x, y, numbers, schematic)
      next unless adjacent_numbers.length == 2

      gear = { coords: [x, y], numbers: adjacent_numbers }
      gears << { coords: [x, y], numbers: adjacent_numbers }
      gear_products << adjacent_numbers.map { |number| number[:number] }.reduce(:*)
    end
  end
  gear_products
end

numbers = find_numbers(schematic)
gear_products = find_gear_products(numbers, schematic)

puts gear_products.sum
