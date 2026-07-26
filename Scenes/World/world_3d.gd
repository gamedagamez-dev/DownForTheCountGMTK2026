extends Node3D

func _ready() -> void:
	$BallDrop.get_node("AnimationPlayer").current_animation = "balldrop"
