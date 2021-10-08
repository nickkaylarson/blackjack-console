# frozen_string_literal: true

require_relative './models/player'
require_relative './models/card'
require_relative 'interface'

class Game
  attr_reader :bank

  def initialize
    @players = []
    @interface = Interface.new
  end

  def start
    2.times { @players << create_player }
    game_loop
  end

  private

  def create_player
    @players.size.zero? ? Player.new('Dealer') : Player.new(@interface.enter_name)
  end

  def make_bid
    bid = 10
    @bank += bid * @players.size
    @players.each { |player| player.bank -= bid }
  end

  def print_player(player)
    @interface.print_message("Player name: #{player.name}")
    player.hand.cards_to_s.each { |card| @interface.print_message(card) }
    @interface.print_message("Points: #{player.hand.calculate_points}")
    @interface.print_message("Bank: #{player.bank}")
    @interface.print_separator
  end

  def add_card(player)
    player.hand.cards = Card.new
  end

  def dealer_move
    if @players.first.hand.cards.size < 3 && @players.first.hand.calculate_points <= 17
      add_card(@players.first)
    else
      @interface.print_message("#{@players.first.name} skip move")
    end
  end

  def show_cards
    @players.each { |player| print_player(player) }
  end

  def check_bank
    if @players.first.bank.positive? && @players.last.bank.positive?
      @interface.start_new_game? ? game_loop : exit
    else
      exit
    end
  end

  def draw
    @interface.print_message('DRAW!')
    @players.each { |player| player.bank += @bank / 2 }
  end

  def victory(player)
    @interface.print_message("#{player.name} won")
    player.bank += @bank
  end

  def choose_winner
    if @players.first.hand.calculate_points > @players.last.hand.calculate_points &&
       @players.first.hand.calculate_points <= 21
      victory(@players.first)
    elsif @players.first.hand.calculate_points == @players.last.hand.calculate_points
      draw
    else
      victory(@players.last)
    end
  end

  def clear_stats
    @bank = 0
    @players.each { |player| player.hand.cards.clear }
  end

  def make_first_move
    2.times { @players.each { |player| add_card(player) } }
    make_bid
  end

  def end_game
    show_cards
    choose_winner
    check_bank
  end

  def aks_choice
    case @interface.player_make_choice
    when 'Skip move'
      dealer_move
    when 'Add a card'
      add_card(@players.last)
      dealer_move
    when 'Show cards'
      end_game
    end
  end

  def game_loop
    clear_stats
    make_first_move
    loop do
      if @players.last.hand.cards.size == 3 || @players.first.hand.cards.size == 3
        end_game
      else
        print_player(@players.last)
        aks_choice
      end
    end
  end
end
