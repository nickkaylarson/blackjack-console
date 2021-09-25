# frozen_string_literal: true

require 'tty-prompt'

class Interface
  def initialize
    @prompt = TTY::Prompt.new(track_history: false)
  end

  def enter_name
    @prompt.ask('Enter your name:')
  end

  def print_message(text)
    p text.to_s
  end

  def print_separator
    puts "\n"
  end

  def start_new_game?
    case @prompt.select('Start new game? : ', %w[Yes No])
    when 'Yes'
      true
    when 'No'
      false
    end
  end

  def player_make_choice
    @prompt.select('Make a choice: ', ['Skip move', 'Add a card', 'Show cards'])
  end
end
