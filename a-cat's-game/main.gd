extends Node

@export var circle_scene : PackedScene
@export var cross_scene : PackedScene

# variable declarations
var player : int
var temp_marker
var player_panel_pos : Vector2i
var grid_data : Array
var grid_pos : Vector2i	#i stands for integer
var board_size	: int
var cell_size	: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	board_size = $Board.texture.get_width()
	# divide board size by 3 to get size of individual cell
	cell_size = board_size / 3
	
	# get coordinates of small panel on right side of window
	player_panel_pos = $PlayerPanel.get_position()
	
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
					# [column][row]
					grid_data[grid_pos.y][grid_pos.x] = player
					
					# place that player's marker / offset mark by half a cell
					create_marker(player, grid_pos * cell_size + Vector2i(cell_size / 2, cell_size / 2))
					
					# other player's turn
					player *= -1
					print(grid_data)

# no _ before func name cuz its not godot-made
func new_game():
	player = 1
	# intialize grid
	grid_data = [
		[0, 0, 0], 
		[0, 0, 0], 
		[0, 0, 0]
		]
		
	# create a marker to show starting player's turn
	create_marker(player, player_panel_pos + Vector2i(cell_size / 2, cell_size / 2), true)

func create_marker(player, position, temp = false):
	# create a marker node and it as a child
	if player == 1:
		var circle = circle_scene.instantiate()
		circle.position = position
		add_child(circle)
		if temp: temp_marker = circle
	elif player == -1:
		var cross = cross_scene.instantiate()
		cross.position = position
		add_child(cross)
		if temp: temp_marker = cross
