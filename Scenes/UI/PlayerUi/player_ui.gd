extends Control

var kisscounter

func _ready() -> void:
	kisscounter = get_node("Kisscontainer/kisscounter") as Label


func updateVampKissed(numKissed: int) -> void:
	kisscounter.text = str(numKissed)

func _on_timer_label_timer_finished() -> void:
	get_tree(). change_scene_to_file("res://Scenes/UI/endScreen/end_screen.tscn")
	

