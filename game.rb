# frozen_string_literal: true

class Game
  def start
    @prompt = TTY::Prompt.new(track_history: false)
    game_loop
  end

  private

  def game_loop; end
end
