# frozen_string_literal: true

class Deck
  attr_accessor :deck

  SUITS = %w[♠ ♥ ♦ ♣].freeze
  VALUES = (2..10).to_a + %w[Jack Queen King Ace]

  def initialize
    @deck = []
    generate_deck
  end

  def card
    card = @deck.sample
    @deck.delete(card)
    card.split
  end

  private

  def generate_deck
    SUITS.each do |suit|
      VALUES.each do |value|
        @deck << "#{suit} #{value}"
      end
    end
  end
end
