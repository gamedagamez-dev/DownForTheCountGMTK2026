extends CharacterBody3D

# Movement settings
@export var speed: float = 7.0
@export var jump_velocity: float = 6
@export var sprint_speed: float = 5.0
@export var sprinting: bool = false
@export var wall_jump_force = 6.0

# Mouse look settings
@export var mouse_sensitivity: float = 0.003
@export var min_pitch: float = -80.0 # Lowest look angle (degrees)
@export var max_pitch: float = 80.0  # Highest look angle (degrees)

@export var vampires_kissed: int = 0

@onready var camera_pivot: Node3D = $Neck
@onready var pause_menu: Control = get_node("PlayerUi/PauseMenu")

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	# Hide the mouse cursor and lock it to the game window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$PlayerUi.updateVampKissed(vampires_kissed)
	Global.current_score = vampires_kissed


func _unhandled_input(event: InputEvent) -> void:
	# Check if the player moved the mouse
	if event is InputEventMouseMotion:
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
	
	# Release the mouse cursor if the player presses UI Cancel (Escape key by default)
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			pause_menu.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			pause_menu.visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		#toggle_pause()
		

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("movement_jump"):
		if is_on_floor():
			velocity.y = jump_velocity
		#elif is_on_wall_only():
			# Get the surface normal of the wall you are touching
		#	var wall_normal = get_last_slide_collision().get_normal()
			
			# Jump up and push away from the wall
		#	velocity.y = jump_velocity
		#	velocity.x = wall_normal.x * wall_jump_force
		#	velocity.z = wall_normal.z * wall_jump_force

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var forward: Vector3 = global_transform.basis.z
	var right: Vector3 = global_transform.basis.x
	var direction := (forward * input_dir.y + right * input_dir.x).normalized()

	if direction:
		velocity.x = direction.x * (speed + (sprint_speed * int(sprinting)))
		velocity.z = direction.z * (speed + (sprint_speed * int(sprinting)))
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func toggle_pause():
	var new_pause_state = !get_tree().paused
	get_tree().paused = new_pause_state
