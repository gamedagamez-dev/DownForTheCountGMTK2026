extends Control


func _ready() -> void:
	get_tree()

#Pressing start loads World3D
func _on_start_button_pressed() -> void:
	get_tree(). change_scene_to_file("res://Scenes/World/World3d.tscn")


#Pressing exit closes game
func _on_exit_button_pressed() -> void:
	get_tree().quit()
