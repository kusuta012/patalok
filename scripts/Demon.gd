extends CharacterBody2D

@export var speed : float = 300.0
@export var max_health = 100
@export var current_health = 100
@export var attack_damage = 25
@export var attack_range = 165.0  # Simple radius - adjust this value as needed

const GRAVITY = 980.0

@onready var animated_sprite = $AnimatedSprite2D
var is_attacking = false
var is_dead = false

func _ready():
	add_to_group("player2")
	current_health = max_health
	if animated_sprite:
		animated_sprite.flip_h = false
		animated_sprite.animation_finished.connect(_on_animated_sprite_2d_animation_finished)

func _physics_process(delta):
	if is_dead:
		return
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if Input.is_action_just_pressed("p2_up") and is_on_floor():
		velocity.y = -500.0
	
	if Input.is_action_just_pressed("p2_attack") and not is_attacking:
		attack()
	
	var direction = Input.get_axis("p2_left", "p2_right")
	
	if direction and not is_attacking:
		velocity.x = direction * speed
		if direction < 0:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()

func attack():
	is_attacking = true
	velocity.x = 0
	animated_sprite.play("attack1")
	await get_tree().create_timer(0.3).timeout
	check_hit()

func check_hit():
	var enemies = get_tree().get_nodes_in_group("player1")
	for enemy in enemies:
		# Use collision shape centers for accurate distance (node origins are offset from visuals)
		var my_center = $CollisionShape2D.global_position
		var enemy_center = enemy.get_node("CollisionShape2D").global_position
		var distance = my_center.distance_to(enemy_center)
		
		print("Player 2 attacking! Distance: ", int(distance), " pixels")
		
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
	print("Player 2 took ", damage, " damage. HP: ", current_health)
	animated_sprite.modulate = Color(1, 0.5, 0.5)
	await get_tree().create_timer(0.2).timeout
	animated_sprite.modulate = Color(1, 1, 1)
	
	if current_health <= 0:
		die()

func die():
	is_dead = true
	velocity = Vector2.ZERO
	current_health = 0
	print("Player 2 died! Player 1 wins round!")
	animated_sprite.modulate = Color(0.3, 0.3, 0.3)
	# Notify Main about round end - player1 wins this round
	var main = get_tree().current_scene
	if main.has_method("round_end"):
		main.round_end("player1")

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "attack1":
		is_attacking = false
