extends CanvasLayer

signal restart



func _on_restart_button_pressed() -> void:
		restart.emit()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_home_button_pressed() -> void:
	# unpause so main can be interacted with
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main.tscn")
