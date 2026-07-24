extends Control

var kisscounter

func _ready() -> void:
	kisscounter = get_node("ColorRect/Kisscontainer/kisscounter") as Label
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	kisscounter.text = str(Global.current_score)

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_main_menu_button_pressed() -> void:
	get_tree(). change_scene_to_file("res://Scenes/UI/MainMenu/MainMenu.tscn")

func _on_restart_button_pressed() -> void:
	get_tree(). change_scene_to_file("res://Scenes/World/World3d.tscn")
