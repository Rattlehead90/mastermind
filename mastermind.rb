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
  attr_reader :current_guess

  def initialize(length = 4)
    until (length.to_i.positive? || length == '' ) && length.to_i.between?(1, 10)
      puts 'Wrong value! Please, enter a number of colors in a sequence: '
      puts 'max: 9 ------------ advised: 4 ------------ minimum: 1'
      length = gets.chomp
    end
    @basic_colors = basic_colors
    @length = length.to_i
    @current_guess = []
    @previous_guess = []
  end

  def create_new
    @colors = Array.new(@length) { rand(@basic_colors.length) }
                   .map { |color_index| @basic_colors[color_index] }
  end

  def make_hash_of_instances
    @current_guess.reduce(Hash.new(0)) do |result, color|
      result[color] += 1
      result
    end
  end

  def let_player_create
    puts "VV Enter #{@length} unique colors as a sequence for the computer to guess VV"
    puts 'Available colors: '
    @basic_colors.each { |color| print "#{color}; " }
    puts
    @colors = gets.chomp.split
    until @colors.length == @length && (@basic_colors - @colors).length == @basic_colors.length - @length
      puts "Erronous input. Please choose from the available colors and be sure to type #{@length} of them correctly."
      @colors = gets.chomp.split
    end
  end

  def guess
    unique_only = false
    feedback = @current_guess.dup
    @current_guess = Array.new(@length) { rand(@basic_colors.length) }
                          .map { |color_index| @basic_colors[color_index] }
    until unique_only
      instances_of_color = make_hash_of_instances
      instances_of_color.each do |color, instances|
        unique_only = true
        if instances > 1
          @current_guess[@current_guess.find_index(color)] = @basic_colors[rand(@basic_colors.length)]
        end
      end
      instances_of_color = make_hash_of_instances
      if instances_of_color.values.any? { |x| x > 1 }
        unique_only = false
      end
    end
    return @current_guess
  end

  def correct?(player)
    guess = []
    puts '                V Input your guess below V                '
    until guess.length == @length && (@basic_colors - guess).length == @basic_colors.length - @length
      puts "Erronous input. Please choose from the available colors and be sure to type #{@length} of them correctly." unless guess == []
      guess = player.guess
    end
    if player.is_a?(Sequence)
      @previous_guess.each_with_index do |guessed_color, index_of_guessed_color| 
        @colors.each_with_index do |sequence_color, index_of_sequence_color|
          if guessed_color == sequence_color && index_of_guessed_color = index_of_sequence_color
            guess[index_of_guessed_color] = sequence_color
          end
        end
      end
    end
    puts 'The current guess is:'
    guess.each { |color| print "#{color}; "}
    puts
    guess == @colors
  end

  def feedback(current_guess)
    @previous_guess = current_guess.dup
    current_guess.each_with_index do |color, index|
      if @colors.include?(color)
        if index == @colors.index(color)
          current_guess[index] = 'B'
        else
          current_guess[index] = 'C'
        end
      else
        current_guess[index] = 'X'
      end
    end
    puts "Result: #{current_guess.join}"
    current_guess
  end
end

# Player class who's making a guess
class Player
  include Colors
  attr_reader :name, :current_guess

  def initialize(name = '')
    @name = name
    @basic_colors = basic_colors
    @current_guess = []
  end

  def guess
    puts 'Available colors: '
    @basic_colors.each { |color| print "#{color}; " }
    puts
    puts 'Input your guess below (e.g. \'black red white green\'): '
    return @current_guess = gets.chomp.split
  end
end

# Game class to orchestrate the game
class Game
  def initialize
    @turn = 1
    greetings unless @player
    rules
    choice = guess_or_create
    if choice == 'G'
      puts 'Select the length of the sequence you\'d dare to crack:'
      puts 'max: 9 ------------ advised: 4 ------------ minimum: 1'
      @sequence = Sequence.new(gets.chomp)
      @sequence.create_new
      play_guess
    elsif choice == 'C'
      puts 'Select the length of the sequence you\'d like to create:'
      puts 'max: 9 ------------ advised: 4 ------------ minimum: 1'
      @sequence = Sequence.new(gets.chomp)
      @sequence.let_player_create
      let_computer_guess
    end
  end

  def guess_or_create
    puts 'Enter \'G\' if you wish to guess the sequence and \'C\' to create one yourself: '
    gets.chomp.upcase
  end

  def greetings
    puts '11__ll11__ll11__ll11__ll11__ll11__ll11__ll11__ll11__ll'
    puts '11__ll11__ll11__ll11__llWELCOME1__ll11__ll11__ll11__ll'
    puts '11__ll11__ll11__ll11__ll11TOll11__ll11__ll11__ll11__ll'
    puts '11__ll11__ll11__ll11__MASTERMIND__ll11__ll11__ll11__ll'
    puts 'What\'s your name? '
    @player = Player.new(gets.chomp)
    puts "Welcome, #{@player.name}, get ready to crack some minds"
  end

  def rules
    puts 'rules*******rules*******rules*******rules*********rules'
    puts 'Guess the secret sequence of unique colors that computer has '
    puts 'generated in order to win. You have 12 turns to do that.'
    puts 'if you\'re answer contains a color that is on it\'s right-'
    puts 'ful place, it\'s a BULL [B] in Result row. If the color is'
    puts 'present in the sequence, but is in a wrong position, it\'s '
    puts 'a COW [C]. X means it\'s not in the sequence.'
    puts 'You can also choose create the sequence for computer to guess!'
  end

  def play_guess
    while @turn <= 12
      puts "                     #{13 - @turn} turns left.           "
      if @sequence.correct?(@player)
        puts 'You have guessed the sequence!'
        break
      end
      @sequence.feedback(@player.current_guess)
      @turn += 1
    end
    puts 'You have failed to guess the sequence!' if @turn > 12
  end

  def let_computer_guess
    while @turn <= 12
      puts "                     #{13 - @turn} turns left.           "
      if @sequence.correct?(@sequence)
        puts 'Computer has guessed the sequence!'
        break
      end
      computer_guess = @sequence.feedback(@sequence.current_guess)
      @turn += 1
    end
    puts 'Computer has failed to guess the sequence!' if @turn > 12
  end
end

Game.new
