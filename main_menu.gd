extends Node2D

var loading_screen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# game starts when button is pressed
func _on_start_button_pressed() -> void:
	loading_screen = load("res://loading_screen.tscn")
	get_tree().change_scene_to_packed(loading_screen)

# quits game when button is pressed
func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_two_player_mode_pressed() -> void:
	loading_screen = load("res://loading_screen_2.tscn")
	get_tree().change_scene_to_packed(loading_screen)
