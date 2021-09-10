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
    end
  end

  def show_cards
    print_player(@players.first)
    print_player(@players.last)
  end

  def start_new_game

    case @prompt.select('Start new game? : ', %w[Yes No])
    when 'Yes'
     
    when 'No'
      
    
    end
  end

  def choose_winner
    if @players.first.points > @players.first.points
        p "#{@players.first.points} won"
    else
        p "#{@players.last.points} won"
    end
    start_new_game
end

  def game_loop
    @players << create_dealer
    @players << create_player
    make_bid
    calculate_points

    loop do
      if @players.last.cards.size == 3
        show_cards
        choose_winner
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
          show_cards
          choose_winner
          break
        end
      end
    end
  end
end
