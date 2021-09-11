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
    @players << create_dealer
    @players << create_player
    game_loop
  end

  private

  def create_dealer
    Player.new('Dealer')
  end

  def create_player
    Player.new(@prompt.ask('Enter your name:'))
  end

  def make_bid
    bid = 10
    @bank += bid * @players.size
    @players.each { |player| player.bank -= bid }
  end

  def calculate_points
    @players.each do |player|
      player.points = 0
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

  def print_player(player)
    p "Player name: #{player.name}"
    player.cards_to_s.each { |card| p card }
    p "Points: #{player.points}"
    p "Bank: #{player.bank}"
    puts "\n"
  end

  def add_card(player)
    player.cards = Card.new
  end

  def dealer_move
    if @players.first.cards.size < 3
      if @players.first.points <= 17
        add_card(@players.first)
        calculate_points
      else
        p "#{@players.first.name} skip move"
      end
    else
      p "#{@players.first.name} skip move"
    end
  end

  def show_cards
    print_player(@players.first)
    print_player(@players.last)
  end

  def start_new_game
    case @prompt.select('Start new game? : ', %w[Yes No])
    when 'Yes'
      game_loop
    when 'No'
      exit
    end
  end

  def check_bank
    if @players.first.bank.positive? && @players.last.bank.positive?
      start_new_game
    else
      exit
    end
  end

  def choose_winner
    if @players.first.points > @players.last.points && @players.first.points <= 21
      p "#{@players.first.name} won"
      @players.first.bank += @bank
    elsif @players.first.points == @players.last.points
        p "DRAW!"
        @players.first.bank += @bank / 2
        @players.last.bank += @bank / 2
    else
      p "#{@players.last.name} won"
      @players.last.bank += @bank
    end
    check_bank
  end

  def clear_stats
    @bank = 0
    @players.each { |player| player.cards.clear }
  end

  def make_first_move
    2.times { @players.each { |player| player.cards = Card.new } }
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
      if @players.last.cards.size == 3 || @players.first.cards.size == 3
        end_game
        break
      else
        print_player(@players.last)
        case @prompt.select('Make a choice: ', ['Skip move', 'Add a card', 'Show cards'])
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
