extends Control


func _on_button_pressed() -> void:
	toggle_pause()
	visible = false
	get_parent().get_parent().get_node("PauseMenu/AudioStreamPlayer").play()

func toggle_pause():
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if get_tree().paused else Input.MOUSE_MODE_CAPTURED)
