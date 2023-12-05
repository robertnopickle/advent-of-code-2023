# frozen_string_literal: true

cards = File.read(ENV.fetch('input')).split("\n")
card_hashes = []

cards.each do |card|
  # remove everything before the first colon
  card = card.split(':').last
  winning_numbers, card_numbers = card.split('|').map(&:strip)

  winning_numbers = winning_numbers.split(' ')
  card_numbers = card_numbers.split(' ')

  matches = winning_numbers & card_numbers

  card_hashes << {
    matches: matches.length,
    copies: 1
  }
end

card_hashes.each_with_index do |card_hash, index|
  matches = card_hash[:matches]
  multiplier = card_hash[:copies]

  next if matches.zero?

  matches.times.with_index do |_, i|
    target_index = index + i + 1
    next if target_index >= card_hashes.length

    card_hashes[index + i + 1][:copies] += 1 * multiplier
  end
end

count = card_hashes.map { |card_hash| card_hash[:copies] }.sum

puts count
