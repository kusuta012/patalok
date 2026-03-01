extends CharacterBody2D

@export var speed : float = 300.0
@export var max_health = 100
@export var current_health = 100
@export var attack_damage = 25
@export var attack_range = 150.0  # Simple radius - adjust this value as needed

const GRAVITY = 980.0

@onready var animated_sprite = $AnimatedSprite2D
var is_attacking = false
var is_dead = false

func _ready():
	add_to_group("player1")
	current_health = max_health
	if animated_sprite:
		animated_sprite.animation_finished.connect(_on_animated_sprite_2d_animation_finished)

func _physics_process(delta):
	if is_dead:
		return
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if Input.is_action_just_pressed("p1_up") and is_on_floor():
		velocity.y = -500.0
	
	if Input.is_action_just_pressed("p1_attack") and not is_attacking:
		attack()
	
	var direction = Input.get_axis("p1_left", "p1_right")
	
	if direction and not is_attacking:
		velocity.x = direction * speed
		if direction > 0:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()

func attack():
	is_attacking = true
	velocity.x = 0
	animated_sprite.play("attack")
	await get_tree().create_timer(0.3).timeout
	check_hit()

func check_hit():
	var enemies = get_tree().get_nodes_in_group("player2")
	for enemy in enemies:
		# Simple true distance check
		var distance = global_position.distance_to(enemy.global_position)
		
		print("Player 1 attacking! Distance: ", int(distance), " pixels")
		
		if distance <= attack_range:
			if enemy.has_method("take_damage"):
				enemy.take_damage(attack_damage)
				print("  ✓ HIT! Dealt ", attack_damage, " damage!")
		else:
			print("  ✗ MISS - Too far! (", int(distance), "/", attack_range, ")")

func take_damage(damage):
	if is_dead:
		return
	current_health -= damage
	print("Player 1 took ", damage, " damage. HP: ", current_health)
	animated_sprite.modulate = Color(1, 0.5, 0.5)
	await get_tree().create_timer(0.2).timeout
	animated_sprite.modulate = Color(1, 1, 1)
	
	if current_health <= 0:
		die()

func die():
	is_dead = true
	velocity = Vector2.ZERO
	current_health = 0
	print("Player 1 died! Player 2 wins!")
	animated_sprite.modulate = Color(0.3, 0.3, 0.3)
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "attack":
		is_attacking = false
