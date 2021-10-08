# frozen_string_literal: true

class Card
  attr_reader :suit, :value

  def initialize(deck)
    @suit, @value = deck.card
  end
end
