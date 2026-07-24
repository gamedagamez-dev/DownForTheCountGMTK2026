extends Control

var kisscounter

func _ready() -> void:
    kisscounter = get_node("Kisscontainer/kisscounter") as Label


func updateVampKissed(numKissed: int) -> void:
    kisscounter.text = str(numKissed)