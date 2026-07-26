extends CharacterBody3D

# Movement settings
@export var speed: float = 7.0
@export var jump_velocity: float = 6
@export var sprint_speed: float = 5.0
@export var sprinting: bool = false
@export var wall_jump_force = 6.0
@export var coyote_time = 0.15
@export var jump_buffer_time = 0.15
@export var acceleration: float = 30.0
@export var friction: float = 120.0
var coyote_timer = 0.0
var jump_buffer_timer = 0.0
var busy = false
var footstep_time = 0.5
var left_ground = 0
# Mouse look settings
@export var mouse_sensitivity: float = 0.003
@export var min_pitch: float = -80.0 # Lowest look angle (degrees)
@export var max_pitch: float = 80.0  # Highest look angle (degrees)

@export var vampires_kissed: int = 0

@onready var camera_pivot: Node3D = $Neck
@onready var pause_menu: Control = get_node("PlayerUi/PauseMenu")
@onready var forward_ray = $Forwardstep
@onready var step_ray = $StepHeight

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var footstep1 = preload("res://Aris/NewFootsteps/Footstep1.wav")
var footstep2 = preload("res://Aris/NewFootsteps/Footstep2.wav")
var footstep3 = preload("res://Aris/NewFootsteps/footstep3.wav")
var footstep4 = preload("res://Aris/NewFootsteps/footstep4.wav")
var footstep5 = preload("res://Aris/NewFootsteps/footstep5.wav")
var landing = preload("res://Aris/NewFootsteps/JumpLanding.wav")
var footstep_list = []

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	toggle_pause()
	# Hide the mouse cursor and lock it to the game window
	$PlayerUi.updateVampKissed(vampires_kissed)
	Global.current_score = vampires_kissed
	footstep_list = [footstep1,footstep2,footstep3,footstep4,footstep5]

func talking_to_baddie(StartOrStop):
	get_node("PlayerUi/PauseMenu/AudioStreamPlayer").stream_paused = StartOrStop
	$RomanceAudioPlayer.playing = StartOrStop

func _unhandled_input(event: InputEvent) -> void:
	# Check if the player moved the mouse
	if event is InputEventMouseMotion and busy == false:
		# 1. Rotate the whole player body left and right (Y-axis)
		rotate_y(-event.relative.x * mouse_sensitivity)
		# 2. Rotate the camera pivot up and down (X-axis)
		camera_pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		
		# 3. Clamp the up/down rotation so the camera doesn't flip upside down
		var clamped_pitch = clamp(
			camera_pivot.rotation_degrees.x, 
			min_pitch, 
			max_pitch
		)
		camera_pivot.rotation_degrees.x = clamped_pitch
	
	# Check if player is sprinting ot not
	if event.is_action_pressed("movement_sprint"):
		sprinting = true
	if event.is_action_released("movement_sprint"):
		sprinting = false
		

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
		coyote_timer -= delta
	else: 
		coyote_timer = coyote_time

	if jump_buffer_timer > 0.0:
		jump_buffer_timer -= delta
	
	if busy == true:
		velocity = Vector3.ZERO
	
	if Input.is_action_just_pressed("movement_jump") and busy == false:
		jump_buffer_timer = jump_buffer_time
		if is_on_floor() or coyote_timer > 0.0:
			velocity.y = jump_velocity + (1.8 * int(Global.current_score >= 2))
			coyote_timer = 0.0
			jump_buffer_timer = 0.0
		#elif is_on_wall_only():
			# Get the surface normal of the wall you are touching
		#	var wall_normal = get_last_slide_collision().get_normal()
			
			# Jump up and push away from the wall
		#	velocity.y = jump_velocity
		#	velocity.x = wall_normal.x * wall_jump_force
		#	velocity.z = wall_normal.z * wall_jump_force

	if is_on_floor() and jump_buffer_timer > 0:
		velocity.y = jump_velocity
		coyote_timer = 0.0
		jump_buffer_timer = 0.0


	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var forward: Vector3 = global_transform.basis.z
	var right: Vector3 = global_transform.basis.x
	var direction := (forward * input_dir.y + right * input_dir.x).normalized()

	if direction and busy == false:
		velocity.x = move_toward(velocity.x, direction.x * (speed + Global.current_score + (sprint_speed * int(sprinting))), acceleration * delta)
		velocity.z = move_toward(velocity.z, direction.z * (speed + Global.current_score + (sprint_speed * int(sprinting))), acceleration * delta)
		if sprinting == true and is_on_floor():
			footstep_time -= delta * 2
		elif  is_on_floor():
			footstep_time -= delta
		if footstep_time <= 0:
			$FootstepAudio.stream = footstep_list[randi() % 5]
			$FootstepAudio.play()
			footstep_time = 0.5
	elif is_on_floor() and busy == false:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		velocity.z = move_toward(velocity.z, 0, friction * delta)
	# else: airborne with no input -> keep current horizontal velocity (no deceleration)
	
	if left_ground >= 0.75 and is_on_floor():
		$LandingAudio.play()
		left_ground = 0

	move_and_slide()
	
	if is_on_floor() == false:
		left_ground += delta

func toggle_pause():
	get_tree().paused = !get_tree().paused
