extends Control

var kisscounter
var initialized = false

#for the audio
var one = preload("res://Aris/downforthecountSFX/TheCount1.wav")
var two = preload("res://Aris/downforthecountSFX/TheCount2.wav")
var three = preload("res://Aris/downforthecountSFX/TheCount3.wav")
var four = preload("res://Aris/downforthecountSFX/TheCount4.wav")
var five = preload("res://Aris/downforthecountSFX/TheCount5.wav")
var six = preload("res://Aris/downforthecountSFX/TheCount6.wav")
var seven = preload("res://Aris/downforthecountSFX/TheCount7.wav")
var eight = preload("res://Aris/downforthecountSFX/TheCount8.wav")
var nine = preload("res://Aris/downforthecountSFX/TheCount9.wav")
var ten = preload("res://Aris/downforthecountSFX/TheCount10.wav")
var over_ten = preload("res://Aris/downforthecountSFX/TheCountLonely.wav")
var number_array = []

func _ready() -> void:
	kisscounter = get_node("Kisscontainer/kisscounter") as Label
	number_array = [one,two,three,four,five,six,seven,eight,nine,ten]


func updateVampKissed(numKissed: int) -> void:
	kisscounter.text = str(numKissed)
	Global.current_score = numKissed
	if initialized:
		$Lipgraphic.visible = true
		$AnimationPlayer.play("Lipunzoom")
		if numKissed < 11:
			$AudioStreamPlayer.stream = number_array[numKissed - 1]
		else:
			$AudioStreamPlayer.stream = over_ten
		$AudioStreamPlayer.playing = true
	else:
		initialized = true

func _on_timer_label_timer_finished() -> void:
	get_tree(). change_scene_to_file("res://Scenes/UI/endScreen/end_screen.tscn")
	
