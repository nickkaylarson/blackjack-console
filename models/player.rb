# frozen_string_literal: true

class Player
  attr_accessor :points, :bank
  attr_reader :name, :cards

  def initialize(name)
    @name = name
    @cards = []
    @bank = 100
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
