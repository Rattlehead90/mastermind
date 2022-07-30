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
# - class sequence with the ability to #create_new and #check if the input is #is_correct?
# - computer class that #guesses and a player which has a @name and @guesses [sanitizing input]
# - class Game itself that has a greeting, initializing
#                             (creating instances of player, computer and sequence classes),
#     finally it should #play a game: repeat the guessing game 12 times giving the assessment

# sequence to geuss
class Sequence
  attr_reader :colors

  def initialize(length = 4)
    @basic_colors = %w[
      red yellow blue green orange pink black white purple
    ]
    @length = length
  end

  def create_new
    @colors = Array.new(@length) { rand(@basic_colors.length) }
                   .map { |color_index| @basic_colors[color_index] }
  end

  def correct?(guess)
    guess == @colors
  end
end
