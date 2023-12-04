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

MAX_RED = 12
MAX_GREEN = 13
MAX_BLUE = 14

games.select! do |game|
  game[:rounds].all? do |round|
    (round[:red].nil? || round[:red] <= MAX_RED) &&
      (round[:green].nil? || round[:green] <= MAX_GREEN) &&
      (round[:blue].nil? || round[:blue] <= MAX_BLUE)
  end
end

ids_sum = games.sum { |game| game[:game_id] }
puts ids_sum
