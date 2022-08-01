# choose whether you want to guess or to make the computer guess the set of colors
# guess the color:
#   computer creates a randomized sets of colors (any amount of colors)
#   player geusses the sequence and recieves the feedback:
#     (correct color in a correct position, correct color in wrong position, incorrect guess)
#   if the player does not suceed under 12 turns the game is lost

# computer makes the guess:
#     player comes up with a sequence
#     computer tries to guess while recieving the output as a person would

# Breaking down the game to classes and objects:
# - class Sequence with the ability to #create_new and #check if the input is #is_correct?
# - Computer class that #guesses and a Player which has a @name and #guesses [sanitizing input]
# - class Game itself that has a greeting, initializing
#                             (creating instances of player, computer and sequence classes),
#     finally it should #play a game: repeat the guessing game 12 times giving the assessment

require 'pry-byebug'

# Colors module that plugs in the basic colors to the game
module Colors
  def basic_colors
    %w[red yellow blue green orange pink black white purple]
  end
end

# Sequence to guess
class Sequence
  include Colors

  def initialize(length = 4)
    until (length.to_i.positive? || length == '' ) && length.to_i.between?(1, 10)
      puts 'Wrong value! Please, enter a number of colors in a sequence: '
      puts 'max: 10 ------------ advised: 4 ------------ minimum: 1'
      length = gets.chomp
    end
    @basic_colors = basic_colors
    @length = length.to_i
  end

  def create_new
    @colors = Array.new(@length) { rand(@basic_colors.length) }
                   .map { |color_index| @basic_colors[color_index] }
  end

  def correct?(guess)
    guess == @colors
  end
end

# Player class who's making a guess
class Player
  include Colors
  attr_reader :name

  def initialize(name)
    @name = name
    @basic_colors = basic_colors
  end

  def guess
    puts 'Input your guess below (e.g. \'black red white green\'): '
    guess = gets.chomp.split
  end
end

# Game class to orchestrate the game
class Game
  def initialize
    @turn = 1
    greetings unless @player
    puts 'Select the length of the sequence you\'d dare to crack:'
    puts 'max: 10 ------------ advised: 4 ------------ minimum: 1'
    @sequence = Sequence.new(gets.chomp)
    puts @sequence.create_new
    play
  end

  def greetings
    puts '11__ll11__ll11__ll11__ll11__ll11__ll11__ll11__ll11__ll'
    puts '11__ll11__ll11__ll11__llWELCOME1__ll11__ll11__ll11__ll'
    puts '11__ll11__ll11__ll11__ll11TOll11__ll11__ll11__ll11__ll'
    puts '11__ll11__ll11__ll11__MASTERMIND__ll11__ll11__ll11__ll'
    puts 'rules*******rules*******rules*******rules*********rules'
    puts 'Guess the secret sequence of colors that computer has '
    puts 'generated in order to win. '
    puts 'What\'s your name? '
    @player = Player.new(gets.chomp)
    puts "Okay, #{@player.name}, you have 12 turns to crack the code."
  end

  def play
    while @turn <= 12
      if @sequence.correct?(@player.guess)
        puts 'You have guessed the sequence!'
        break
      end
      @turn += 1
    end
    puts 'You have failed to guess the sequence!' if @turn > 12
  end
end

Game.new