# frozen_string_literal: true

require_relative './models/player'
require_relative './models/card'
require_relative 'interface'

class Game
  attr_reader :bank

  def initialize
    @players = []
    @bank = 0
    @interface = Interface.new
  end

  def start
    2.times { @players << create_player }
    game_loop
  end

  private

  def create_player
    if @players.size.zero?
      Player.new('Dealer')
    else
      Player.new(@interface.enter_name)
    end
  end

  def make_bid
    bid = 10
    @bank += bid * @players.size
    @players.each { |player| player.bank -= bid }
  end

  def calculate_points
    @players.each do |player|
      player.hand.calculate_points
    end
  end

  def print_player(player)
    @interface.print_message("Player name: #{player.name}")
    player.hand.cards_to_s.each { |card| @interface.print_message(card) }
    @interface.print_message("Points: #{player.hand.points}")
    @interface.print_message("Bank: #{player.bank}")
    @interface.print_separator
  end

  def add_card(player)
    player.hand.cards = Card.new
  end

  def dealer_move
    if @players.first.hand.cards.size < 3
      if @players.first.hand.points <= 17
        add_card(@players.first)
        calculate_points
      else
        @interface.print_message("#{@players.first.name} skip move")
      end
    else
      @interface.print_message("#{@players.first.name} skip move")
    end
  end

  def show_cards
    print_player(@players.first)
    print_player(@players.last)
  end

  def check_bank
    if @players.first.bank.positive? && @players.last.bank.positive?
      @interface.start_new_game? ? game_loop : exit
    else
      exit
    end
  end

  def choose_winner
    if @players.first.hand.points > @players.last.hand.points && @players.first.hand.points <= 21
      @interface.print_message("#{@players.first.name} won")
      @players.first.bank += @bank
    elsif @players.first.hand.points == @players.last.hand.points
      @interface.print_message('DRAW!')
      @players.first.bank += @bank / 2
      @players.last.bank += @bank / 2
    else
      @interface.print_message("#{@players.last.name} won")
      @players.last.bank += @bank
    end
    check_bank
  end

  def clear_stats
    @bank = 0
    @players.each { |player| player.hand.cards.clear }
  end

  def make_first_move
    2.times { @players.each { |player| add_card(player) } }
    make_bid
    calculate_points
  end

  def end_game
    show_cards
    choose_winner
  end

  def game_loop
    clear_stats
    make_first_move
    loop do
      if @players.last.hand.cards.size == 3 || @players.first.hand.cards.size == 3
        end_game
        break
      else
        print_player(@players.last)
        case @interface.player_make_choise
        when 'Skip move'
          dealer_move
          calculate_points
        when 'Add a card'
          add_card(@players.last)
          dealer_move
          calculate_points
        when 'Show cards'
          end_game
          break
        end
      end
    end
  end
end
