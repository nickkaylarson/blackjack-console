# frozen_string_literal: true

class Deck
  SUIT = %w[♠ ♥ ♦ ♣].freeze
  VALUE = (2...10).to_a + %w[Jack Queen King Ace]

  def random_card
    [SUIT.sample, VALUE.sample]
  end
end
