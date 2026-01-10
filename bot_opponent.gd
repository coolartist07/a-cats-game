extends Node

@export var coin_scene : PackedScene
@export var scratch_scene : PackedScene

# variable declarations
var player : int
var moves : int
var winner : int
var temp_marker
var player_panel_pos : Vector2i
var grid_data : Array
var grid_pos : Vector2i	#i stands for integer
var board_size	: int
var cell_size	: int
var row_sum : int
var col_sum : int
var diagonal_sum : int
var diagonal2 : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	board_size = $Board.texture.get_width()
	# divide board size by 10.24 to get size of individual cell (texture is big)
	cell_size = board_size / 10.24
	
	# get coordinates of small panel on right side of window
	player_panel_pos = $NextPlayerPanel.get_position()
	
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# check if mouse is on game board
			if event.position.x < board_size:
				# convert mouse position into grid location
				grid_pos = Vector2i(event.position / cell_size)
				
				# check if cell is empty
				if grid_data[grid_pos.y][grid_pos.x] == 0:
					moves += 1
					# [column][row]
					grid_data[grid_pos.y][grid_pos.x] = player
					
					# place that player's marker / offset mark by half a cell
					create_marker(player, grid_pos * cell_size + Vector2i(cell_size / 2, cell_size / 2))
					
					check_game_over()

					# other player's turn
					player *= -1
					
					# update the panel marker
					temp_marker.queue_free() # hides the previous mark
					create_marker(player, player_panel_pos + Vector2i(cell_size / 2, cell_size / 2), true)

					
					print(grid_data)

# no _ before func name cuz its not godot-handled
func new_game():
	player = 1
	moves = 0
	winner = 0
	# intialize grid
	grid_data = [
		[0, 0, 0], 
		[0, 0, 0], 
		[0, 0, 0]
		]

	# reset board variables
	row_sum = 0
	col_sum = 0
	diagonal_sum = 0
	diagonal2 = 0
	
	# clear existing markers
	get_tree().call_group("coins", "queue_free")
	get_tree().call_group("scratches", "queue_free")

	# create a marker to show starting player's turn
	create_marker(player, player_panel_pos + Vector2i(cell_size / 2, cell_size / 2), true)
	$GameOverMenu.hide()
	
	# unpause the game
	get_tree().paused = false
func create_marker(player, position, temp = false):
	# create a marker node and it as a child
	if player == 1:
		var lucky_coin = coin_scene.instantiate()
		lucky_coin.position = position
		add_child(lucky_coin)
		if temp: temp_marker = lucky_coin
	elif player == -1:
		var scratch = scratch_scene.instantiate()
		scratch.position = position
		add_child(scratch)
		if temp: temp_marker = scratch

func check_win():
	# add up the marker in each row, column, and diagonal
	for i in len(grid_data):
		row_sum = grid_data[i][0] + grid_data[i][1] + grid_data[i][2]
		col_sum = grid_data[0][i] + grid_data[1][i] + grid_data[2][i]
		diagonal_sum = grid_data[0][0] + grid_data[1][1] + grid_data[2][2]
		diagonal2 = grid_data[0][2] + grid_data[1][1] + grid_data[2][0]

	# check if either player has all of the markers in one line
		if row_sum == 3 or col_sum == 3 or diagonal_sum == 3 or diagonal2 == 3:
			winner = 1
		elif row_sum == -3 or col_sum == -3 or diagonal_sum == -3 or diagonal2 == -3:
			winner = -1

	return winner


func check_game_over():
	if check_win() != 0:
	# if there's a winner, game won't continue
		get_tree().paused = true
						
	# show game over menu
		$GameOverMenu.show()
					
		if winner == 1:
			$GameOverMenu.get_node("ResultLabel").text = "Player 1 Wins!"
							
		elif winner == -1:
			$GameOverMenu.get_node("ResultLabel").text = "Player 2 Wins!"
								
		# check if the board is filled (tie game)
		elif moves == 9:
			get_tree().paused = true
			$GameOverMenu.show()
			$GameOverMenu.get_node("ResultLabel").text = "Cat's Game!"
		

#func bot_get_cell():
	


func _on_game_over_menu_restart() -> void:
	new_game()
