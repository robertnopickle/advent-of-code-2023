# frozen_string_literal: true

cards = File.read(ENV.fetch('input')).split("\n")

points = 0

cards.each do |card|
  # remove everything before the first colon
  card = card.split(':').last
  winning_numbers, card_numbers = card.split('|').map(&:strip)

  winning_numbers = winning_numbers.split(' ')
  card_numbers = card_numbers.split(' ')

  matches = winning_numbers & card_numbers

  binary_score = ''
  matches.length.times do
    binary_score += '0'
  end

  unless matches.empty?
    binary_score = binary_score.chars
    binary_score.pop
    binary_score = binary_score.push('1').reverse.join('')
    points += binary_score.to_i(2)
  end
end

puts points
