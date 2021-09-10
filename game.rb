# frozen_string_literal: true

require 'tty-prompt'

require_relative('./models/player')
require_relative('./models/card')

class Game
  attr_reader :bank

  def initialize
    @players = []
    @bank = 0
  end

  def start
    @prompt = TTY::Prompt.new(track_history: false)
    game_loop
  end

  private

  def create_dealer
    dealer = Player.new('Dealer')
    2.times { dealer.cards = Card.new }
    dealer
  end

  def create_player
    player = Player.new(@prompt.ask('Enter your name:'))
    2.times { player.cards = Card.new }
    player
  end

  def make_bid
    bid = 10
    @bank += bid * @players.size
    @players.each { |player| player.bank -= bid }
  end

  def calculate_points
    @players.each do |player|
      player.cards.each do |card|
        player.points += if card.value.to_i.zero?
                           card.value == 'Ace' ? 1 : 10
                         else
                           card.value.to_i
                         end

        player.points += 10 if card.value == 'Ace' && (player.points + 10) <= 21
      end
    end
  end

  def print_cards_and_points
    @players.last.cards_to_s.each { |card| p card }
    p "Points: #{@players.last.points}"
  end

  def make_choise; end

  def game_loop
    loop do
      @players << create_dealer
      @players << create_player
      make_bid
      calculate_points
      print_cards_and_points
      #   make_choise

      # binding.irb
    end
  end
end
