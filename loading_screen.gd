extends Control

var progress = []
var scene_name
var scene_load_status = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# use signals to know which button was pressed for which event
	scene_name = "res://bot_opponent.tscn"
	ResourceLoader.load_threaded_request(scene_name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scene_load_status = ResourceLoader.load_threaded_get_status(scene_name, progress)
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var new_scene = ResourceLoader.load_threaded_get(scene_name)
		get_tree().change_scene_to_packed(new_scene)
