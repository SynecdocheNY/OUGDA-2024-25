extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass # Replace with function body.

func _unhandled_input(event):
	if event is InputEventKey:
		if event.keycode == KEY_SPACE:
			get_tree().change_scene_to_file("res://Scenes/Levels/Level1.tscn")
