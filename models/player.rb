# frozen_string_literal: true

class Player
  attr_accessor :points
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
    @cards.each do |card|
      cards << "#{card.value} #{card.suit}"
    end
    cards
  end
end
