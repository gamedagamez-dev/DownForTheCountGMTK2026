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
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if get_tree().paused or get_parent().get_parent().busy else Input.MOUSE_MODE_CAPTURED)
	$AudioStreamPlayer.stream_paused = true if get_tree().paused or get_parent().get_parent().busy else false
	

func _on_h_slider_drag_ended(value_changed: bool) -> void:
	var actual_sensitivity: float = get_node("SensContainer/HSlider").value * (0.003 / 50.0)
	get_parent().get_parent().mouse_sensitivity = actual_sensitivity


func _on_music_slider_drag_ended(value_changed: bool) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"),(get_node("SensContainer2/music_slider").value - 100)/3)
	if get_node("SensContainer2/music_slider").value == 0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("music"),true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("music"),false)



func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sfx"),(get_node("SensContainer2/music_slider").value - 100)/3)
	if get_node("SensContainer2/music_slider").value == 0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("sfx"),true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("sfx"),false)
