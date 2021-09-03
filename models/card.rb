# frozen_string_literal: true

class Card
  SUIT = %w[♠ ♥ ♦ ♣].freeze

  VALUE = (2...10).to_a + %w[Jack Queen King Ace]

  attr_accessor :suit, :value

  def initialize
    @suit = SUIT.sample
    @value = VALUE.sample
  end
end
