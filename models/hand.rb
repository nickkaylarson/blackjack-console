# frozen_string_literal: true

class Hand
  attr_accessor :points
  attr_reader :cards

  def initialize
    @cards = []
    @points = 0
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
end
