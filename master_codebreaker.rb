class GameLogic # The game logic
	def initialize(player)
		@player = player
		@board = Board.new
		@turn = 0
		@secret_code = Array.new
		generate_code
	end

	def play # Plays one game of Master Codebreaker
		puts "Try to guess the computer player's secret code in 12 turns!"
		puts "A black key peg means that one of your guesses is correct both in color and placement."
		puts "A white key peg means that one of your guesses is correct in color but not in placement.\n"
		while 1
			@turn += 1
			player_turn
			if winner?
				puts "You are victorious in #{@turn} turn(s)!\n"
				@player.wins += 1
				if @player.best > @turn || @player.best == -1
					@player.best = @turn
				end
				return 
			end
			if @turn >= 12
				puts "You have been defeated!\n"
				@player.losses += 1
				return
			end
		end
	end

	private

	def generate_code # Generates and returns the computer player's secret code
		color = ["G", "B", "R", "P", "Y", "O"]
		4.times do
			@secret_code.push(color[Random.rand(0..5)])
		end
	end

	def player_turn
		begin
			puts "#{player.name}, guess the secret code.  The colors are red, green, blue, yellow, purple, and orange."
			puts "Colors may be used more than once."
			puts "Peg 1: "
			peg1_guess = gets.chomp.upcase
			puts "Peg 2: "
			peg2_guess = gets.chomp.upcase
			puts "Peg 3: "
			peg3_guess = gets.chomp.upcase
			puts "Peg 4: "
			peg4_guess = gets.chomp.upcase
			raise ArgumentError if guess_error?(peg1_guess) || guess_error?(peg2_guess) || guess_error?(peg3_guess) || guess_error?(peg4_guess)
		rescue
			puts "You must enter one of the six listed colors."
			retry
		end
	end

	def guess_error?(guess)
		return !(guess == "RED" || guess == "BLUE" || guess == "GREEN" || guess == "ORANGE" || guess == "YELLOW" || guess == "PURPLE" || guess == "R" || guess == "B" || guess == "G" || guess == "O" || guess == "Y" || guess == "P")
	end

	def winner?
		if @board.get_key_peg(@turn, 1) == "B" && @board.get_key_peg(@turn, 1) == @board.get_key_peg(@turn, 2) && @board.get_key_peg(@turn, 2) == @board.get_key_peg(@turn, 3) && @board.get_key_peg(@turn, 3) == @board.get_key_peg(@turn, 4)
			return true
		else
			return false
		end
	end

end

class Board # Manages the creation and manipulation of the game board

	def initialize
		@row = Array.new(12)
		(0..11).each do |index|
			@row[index] = Hash.new
			@row[index][:code_peg] = []
			@row[index][:key_peg] = []
		end
	end

	# Fills the code pegs of one row
	def fill_code_row(row, peg1, peg2, peg3, peg4)
		@row[row-1][:code_peg] = [peg1, peg2, peg3, peg4]
	end

	# Fills the key pegs of one row
	def fill_key_row(row, peg1="E", peg2="E", peg3="E", peg4="E")
		@row[row-1][:key_peg] = [peg1, peg2, peg3, peg4]
	end

	# Returns the value of a code peg from a given row
	def get_code_peg(row, peg_num)
		@row[row-1][:code_peg][peg_num-1]
	end

	# Returns the value of a key peg from a given row
	def get_key_peg(row, peg_num)
		@row[row-1][:key_peg][peg_num-1]
	end

	def print_board(turn) #Prints the current game board (filled portion only)
		(0...turn).each do |row_index|
			print "Row #{row_index+1}: Code Pegs: "
			(0..3).each do |code_index|
				print "#{@row[row_index][:code_peg][code_index]} "
			end
			print "Key Pegs: "
			(0..3).each do |key_index|
				print "#{@row[row_index][:key_peg][key_index]} "
			end
			puts
		end
	end
end

Player = Struct.new(:name, :wins, :losses, :best)

Code = Struct.new(:code1, :code2, :code3, :code4)

begin
	puts "Please enter your name: "
	player = Player.new(gets.chomp, 0, 0, -1)
	raise ArgumentError if player.name.empty?
rescue
	puts "You must enter a name to continue."
	retry
end

play_again = true
while play_again
	puts "\nLet's play!\n"
 	game = GameLogic.new(player)
	game.play
	

	puts "\n#{player.name}, you have won #{player.wins} game(s) and lost #{player.losses} game(s)."
	puts "Your best scores is #{player.best} turn(s)." if player.best != -1
	puts "Would you like to play again (yes/no)? "
	begin
		keep_playing = gets.chomp
		raise ArgumentError if keep_playing != "yes" && keep_playing != "Yes" && keep_playing != "no" && keep_playing != "No"
	rescue
		puts "Please enter either 'yes' or 'no'. "
		retry
	end
	play_again = (keep_playing == "yes" || keep_playing == "Yes") ? true : false
end

puts "\nThanks for playing Master Codebreaker, #{player.name}!"
puts "You won #{player.wins} games and lost #{player.losses} games."
puts "Your best score was #{player.best} turn(s)." if player.best != -1
