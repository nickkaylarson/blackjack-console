# frozen_string_literal: true

require 'tty-prompt'

require_relative('./models/player')
require_relative('./models/card')

class Game
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



  def game_loop
    loop do
    @players << create_dealer
    @players << create_player
    end
  end
end
