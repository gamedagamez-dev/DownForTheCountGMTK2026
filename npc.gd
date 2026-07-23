extends Node3D
@export var tree_size = 0
@export var _name = ""
@export var question_1 = ""
@export var Q1_answer_correct = ""
@export var Q1_answer_wrong = ""
@export var question_2 = " "
@export var Q2_answer_correct = ""
@export var Q2_answer_wrong = ""
@export var question_3 = " "
@export var Q3_answer_correct = ""
@export var Q3_answer_wrong = ""
@export var Conclusion = ""
@export var Failure = ""
var progress = 0
var correct_answer = 0
var selected_answer
var correct_answer_list = [0]
var wrong_answer_list = [0]
var question_list
signal selected()

func _ready() -> void:
	dialogue_start()
func dialogue_start():
	correct_answer = randi() % 1
	print(correct_answer)
	$Control/dialogue.text = question_1
	if correct_answer == 0:
		$Control/answer_1.text = Q1_answer_correct
		$Control/answer_2.text = Q1_answer_wrong
	if correct_answer == 0:
		$Control/answer_2.text = Q1_answer_correct
		$Control/answer_1.text = Q1_answer_wrong
	await selected
	print(selected_answer,", ",Q1_answer_correct)
	if Q1_answer_correct == selected_answer:
		progress += 1
		dialogue_start()
	else:
		$Control/dialogue.text = Failure
	


func _on_answer_1_button_down() -> void:
	selected_answer = $Control/answer_1.text
	emit_signal("selected")


func _on_answer_2_button_down() -> void:
	selected_answer = $Control/answer_2.text
	emit_signal("selected")
