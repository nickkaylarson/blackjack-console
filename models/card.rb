# frozen_string_literal: true

require_relative 'deck'

class Card
  attr_reader :suit, :value

  def initialize
    @suit, @value = Deck.new.random_card
  end
end
