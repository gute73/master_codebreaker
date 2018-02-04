class GameLogic # The game logic
	def initialize(player)
		@player = player
		@board = Board.new
		@secret_code = generate_code
	end

	def play # Plays one game of Master Codebreaker

	end

	def generate_code # Generates and returns the computer player's secret code

	end

end

class Board # Manages the creation and manipulation of the game board
	def initialize
		@row = Array.new(12)
		(0..11).each do |index|
			@row[index] = Hash.new
			@row[index]["code peg"] = []
			@row[index]["key peg"] = []
		end
		@last_index_filled = 0
	end

	# Fills the code pegs of one row
	def fill_code_row(row, peg1, peg2, peg3, peg4)
		@row[row-1]["code peg"] = [peg1, peg2, peg3, peg4]
		@last_index_filled = row-1
	end

	# Fills the key pegs of one row
	def fill_key_row(row, peg1="E", peg2="E", peg3="E", peg4="E")
		@row[row-1]["key peg"] = [peg1, peg2, peg3, peg4]
	end

	# Returns the value of a code peg from a given row
	def get_code_peg(row, peg_num)
		@row[row-1]["code peg"][peg_num-1]
	end

	# Returns the value of a key peg from a given row
	def get_key_peg(row, peg_num)
		@row[row-1]["key peg"][peg_num-1]
	end

	def print_board #Prints the current game board (filled portion only)
		(0..last_index_filled).each do |row_index|
			print "Row #{row_index+1}: Code Pegs: "
			(0..3).each do |code_index|
				print "#{@row[row_index]['code peg'][code_index]} "
			end
			print "Key Pegs: "
			(0..3).each do |key_index|
				print "#{@row[row_index]['key peg'][key_index]} "
			end
			puts
		end
	end
end

Player = Struct.new(:name, :wins, :losses, :best)

Code = Struct.new(:code1, :code2, :code3, :code4)

color = ["green", "blue", "red", "purple", "yellow", "orange"]

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
#	game = GameLogic.new(player)
#	game.play

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
