extends Node3D
@export var tree_size = 0
@export var _name = ""
@export var question_1 = ""
@export var Q1_answer_correct = ""
@export var Q1_answer_wrong = ""
@export var Q1_failure = ""
@export var question_2 = " "
@export var Q2_answer_correct = ""
@export var Q2_answer_wrong = ""
@export var Q2_failure = ""
@export var question_3 = " "
@export var Q3_answer_correct = ""
@export var Q3_answer_wrong = ""
@export var Q3_failure = ""
@export var Conclusion = ""
@export var Failure = ""
@export var Already_Failed = ""
@export var Already_Succeceded = ""
var progress = 0
var correct_answer = 0
var selected_answer
var correct_answer_list = [0]
var wrong_answer_list = [0]
var question_list = [0]
var failure_list = [0]
var scrolling = false
var outcome = 0 #0 = not talked to, 1 = success, 2 = failure
var already_smooched = false
signal selected()

func _ready() -> void:
	$Control.visible = false
	correct_answer_list = [Q1_answer_correct,Q2_answer_correct,Q3_answer_correct,"cal_past_index"]
	wrong_answer_list = [Q1_answer_wrong,Q2_answer_wrong,Q3_answer_wrong,"wal_past_index"]
	question_list = [question_1,question_2,question_3,"ql_past_index"]
	failure_list = [Q1_failure,Q2_failure,Q3_failure,"fl_past_index"]

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_page_down"):
		dialogue_start()

func dialogue_start():
	$Control.visible = true
	if tree_size == 0:
		$Control/dialogue.text = Conclusion
		$Control/dialogue.visible_characters = -1
		outcome = 1
		$Control/answer_1.text = "smooch em'"
		$Control/answer_2.visible = false
		await $Control/answer_1.button_down
		is_talk = false
		$Control.visible = false
		return
	if outcome == 1:
		$Control/dialogue.text = Already_Succeceded
		$Control/dialogue.visible_characters = -1
		$Control/answer_1.text = "Leave"
		$Control/answer_2.visible = false
		await $Control/answer_1.button_down
		is_talk = false
		$Control.visible = false
	elif outcome == 2:
		$Control/dialogue.text = Already_Failed
		$Control/dialogue.visible_characters = -1
		$Control/answer_1.text = "Leave"
		$Control/answer_2.visible = false
		await $Control/answer_1.button_down
		is_talk = false
		$Control.visible = false
	else:
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
		$Control/answer_1.disabled = true
		$Control/answer_2.disabled = true
		scroll()
		await selected
		scrolling = false
		if correct_answer_list[progress] == selected_answer:
			progress += 1
			if progress == tree_size:
				$Control/dialogue.text = Conclusion
				$Control/dialogue.visible_characters = -1
				outcome = 1
				$Control/answer_1.text = "smooch em'"
				$Control/answer_2.visible = false
				await $Control/answer_1.button_down
				is_talk = false
				$Control.visible = false
				return
			else:
				dialogue_start()
		else:
			$Control/dialogue.text = failure_list[progress]
			$Control/dialogue.visible_characters = -1
			outcome = 2
			$Control/answer_1.text = "Leave"
			$Control/answer_2.visible = false
			await $Control/answer_1.button_down
			is_talk = false
			$Control.visible = false

func scroll():
	while scrolling == true:
		$Control/dialogue.visible_characters += 1
		if $Control/dialogue.visible_characters >= $Control/dialogue.text.length():
			scrolling = false
			break
		if Input.is_action_pressed("skipDialogue"):
			$Control/dialogue.visible_characters = -1
			scrolling = false
			break
		await get_tree().create_timer(1.0/15).timeout
	$Control/answer_1.disabled = false
	$Control/answer_2.disabled = false

func _on_answer_1_button_down() -> void:
	selected_answer = $Control/answer_1.text
	emit_signal("selected")


func _on_answer_2_button_down() -> void:
	selected_answer = $Control/answer_2.text
	emit_signal("selected")



var can_talk = false
var is_talk = false
func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("interaction_check"):
		can_talk = true
		$Sprite3D.visible = true
		while can_talk == true:
			if Input.is_action_just_pressed("interaction"):
				$Sprite3D.visible = false
				is_talk = true
				area.get_parent().look_at(Vector3(position.x,area.global_position.y,position.z))
				area.get_parent().busy = true
				dialogue_start()
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				while is_talk == true:
					Global.timer_running = false
					await get_tree().create_timer(1.0/240).timeout
				Global.timer_running = true
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				is_talk = false
				if outcome == 1 and not already_smooched:
					area.get_parent().vampires_kissed += 1
					area.get_parent().get_node("PlayerUi").updateVampKissed(area.get_parent().vampires_kissed)
					already_smooched = true
				
				area.get_parent().busy = false
			await get_tree().create_timer(1.0/240).timeout


func _on_area_3d_area_exited(area: Area3D) -> void:
	if area.is_in_group("interaction_check"):
		can_talk = false
		$Sprite3D.visible = false


func _on_selected() -> void:
	pass # scroll state is fully handled in dialogue_start() after `await selected`
