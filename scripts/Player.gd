extends CharacterBody2D

@export var speed : float = 300.0

const GRAVITY = 980.0

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Handle jump
	if Input.is_action_just_pressed("move_up") and is_on_floor():
		velocity.y = -500.0

	# Handle attack
	if Input.is_action_just_pressed("attack"):
		animated_sprite.play("attack")

	# Get the horizontal input direction
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
