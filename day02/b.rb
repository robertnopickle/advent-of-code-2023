# frozen_string_literal: true

# begin parseing

games_input = File.read(ENV.fetch('input')).split("\n")

def parse_game(input)
  game_id = input.match(/Game (\d+):/)[1].to_i
  input.gsub!(/Game \d+: /, '')

  game = input.split(';').map do |round_input|
    parse_round(round_input)
  end

  [game_id, game]
end

def parse_round(round_input)
  round = {}
  round_input.strip.split(',').map do |count_and_color|
    count, color = count_and_color.strip.split(' ')
    round[color.to_sym] = count.to_i
  end
  round
end

games = []

games_input.each do |game_input|
  game_id, rounds = parse_game(game_input)
  games << { game_id: game_id, rounds: rounds }
end

# end parsing

games_powers = games.map do |game|
  least_red = 0
  least_green = 0
  least_blue = 0

  game[:rounds].each do |round|
    least_red = [least_red, round[:red] || 0].max
    least_green = [least_green, round[:green] || 0].max
    least_blue = [least_blue, round[:blue] || 0].max
  end

  least_red * least_green * least_blue
end

puts games_powers.sum
