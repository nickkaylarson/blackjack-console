# frozen_string_literal: true

require_relative 'hand'

class Player
  attr_accessor :bank
  attr_reader :name, :hand

  def initialize(name)
    @name = name
    @bank = 100
    @hand = Hand.new
  end
end
