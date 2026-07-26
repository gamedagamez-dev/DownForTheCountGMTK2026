extends Control

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_main_menu_button_pressed() -> void:
	toggle_pause()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree(). change_scene_to_file("res://Scenes/UI/MainMenu/MainMenu.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if get_tree().paused else Input.MOUSE_MODE_CAPTURED)

func _on_h_slider_drag_ended(value_changed: bool) -> void:
	var actual_sensitivity: float = get_node("SensContainer/HSlider").value * (0.003 / 50.0)
	get_parent().get_parent().mouse_sensitivity = actual_sensitivity
