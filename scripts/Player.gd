extends CharacterBody2D

@export var speed := 300.0
@export var jump_velocity := -300.0
@export var gravity := 1200.0

func _physics_process(delta):

	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Jump
	if Input.is_action_just_pressed("move_up") and is_on_floor():
		velocity.y = jump_velocity

	# Left / Right movement
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed

	move_and_slide()
