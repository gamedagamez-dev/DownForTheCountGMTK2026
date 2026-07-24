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
var question_list = [0]
var scrolling = false
signal selected()

func _ready() -> void:
	correct_answer_list = [Q1_answer_correct,Q2_answer_correct,Q3_answer_correct]
	wrong_answer_list = [Q1_answer_wrong,Q2_answer_wrong,Q3_answer_wrong]
	question_list = [question_1,question_2,question_3]
	dialogue_start()

func dialogue_start():
	$Control/dialogue.visible_characters = 0
	$Control/name.text = _name
	correct_answer = randi() % 2
	print (correct_answer)
	print(correct_answer)
	$Control/dialogue.text = question_list[progress]
	
	if correct_answer == 0:
		$Control/answer_1.text = correct_answer_list[progress]
		$Control/answer_2.text = wrong_answer_list[progress]
	if correct_answer == 1:
		$Control/answer_2.text = correct_answer_list[progress]
		$Control/answer_1.text = wrong_answer_list[progress]
	scrolling = true
	scroll()
	await selected
	scrolling = false
	if correct_answer_list[progress] == selected_answer:
		progress += 1
		if progress == tree_size:
			$Control/dialogue.text = Conclusion
		else:
			dialogue_start()
	else:
		$Control/dialogue.text = Failure
	

func scroll():
	while scrolling == true:
		$Control/dialogue.visible_characters += 1
		await get_tree().create_timer(1.0/10).timeout

func _on_answer_1_button_down() -> void:
	selected_answer = $Control/answer_1.text
	emit_signal("selected")


func _on_answer_2_button_down() -> void:
	selected_answer = $Control/answer_2.text
	emit_signal("selected")
