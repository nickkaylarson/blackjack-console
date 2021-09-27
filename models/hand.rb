# frozen_string_literal: true

class Hand
  attr_reader :cards

  def initialize
    @cards = []
  end

  def cards=(card)
    @cards << card
  end

  def cards_to_s
    cards = []
    @cards.each_with_index do |card, index|
      cards << "Card ##{index + 1}: #{card.value} #{card.suit}"
    end
    cards
  end

  def calculate_points
    points = 0
    @cards.each do |card|
      points += if card.value.to_i.zero?
                  card.value == 'Ace' ? 1 : 10
                else
                  card.value.to_i
                end
      points += 10 if card.value == 'Ace' && (points + 10) <= 21
    end
    points
  end
end
