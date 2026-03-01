#extends CharacterBody2D
#
#@export var speed : float = 300.0
#@export var max_health = 100
#@export var current_health = 100
#@export var attack_damage = 25
#@export var attack_range = 100.0
#
#const GRAVITY = 980.0
#
#@onready var animated_sprite = $AnimatedSprite2D
#var is_attacking = false
#var is_dead = false
#
#func _ready():
	#add_to_group("player2")
#
#func _physics_process(delta):
	#if is_dead:
		#return
	#
	#if not is_on_floor():
		#velocity.y += GRAVITY * delta
	#
	#if Input.is_action_just_pressed("p2_up") and is_on_floor():
		#velocity.y = -500.0
	#
	#if Input.is_action_just_pressed("p2_attack") and not is_attacking:
		#attack()
	#
	#var direction = Input.get_axis("p2_left", "p2_right")
	#
	#if direction:
		#velocity.x = direction * speed
		#if direction > 0:
			#animated_sprite.flip_h = false
		#else:
			#animated_sprite.flip_h = true
	#else:
		#velocity.x = move_toward(velocity.x, 0, speed)
	#
	#move_and_slide()
#
#func attack():
	#is_attacking = true
	#animated_sprite.play("attack1")
	#await get_tree().create_timer(0.2).timeout
	#check_hit()
#
#func check_hit():
	#var enemies = get_tree().get_nodes_in_group("player1")
	#for enemy in enemies:
		#var distance = global_position.distance_to(enemy.global_position)
		#if distance <= attack_range:
			#if enemy.has_method("take_damage"):
				#enemy.take_damage(attack_damage)
				#print("Player 2 hit Player 1 for ", attack_damage, " damage!")
#
#func take_damage(damage):
	#if is_dead:
		#return
	#current_health -= damage
	#print("Player 2 took ", damage, " damage. HP: ", current_health)
	#if current_health <= 0:
		#die()
#
#func die():
	#is_dead = true
	#velocity = Vector2.ZERO
	#print("Player 2 died! Player 1 wins!")
	#animated_sprite.modulate = Color(0.5, 0.5, 0.5)
#
#func _on_animated_sprite_2d_animation_finished():
	#if animated_sprite.animation == "attack1":
		#is_attacking = false

extends CharacterBody2D

@export var speed : float = 300.0
@export var max_health = 100
@export var current_health = 100
@export var attack_damage = 25
@export var attack_range = 100.0

const GRAVITY = 980.0

@onready var animated_sprite = $AnimatedSprite2D
var is_attacking = false
var is_dead = false

func _ready():
	add_to_group("player2")
	# Connect the animation finished signal
	if animated_sprite:
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
	
	if direction:
		velocity.x = direction * speed
		# FIXED: Flip direction for demon (might need opposite depending on your sprite)
		if direction < 0:  # Moving left
			animated_sprite.flip_h = true
		else:  # Moving right
			animated_sprite.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()

func attack():
	is_attacking = true
	animated_sprite.play("attack1")
	await get_tree().create_timer(0.2).timeout
	check_hit()
	# Fallback: Reset attacking after animation duration
	await get_tree().create_timer(0.5).timeout
	is_attacking = false

func check_hit():
	var enemies = get_tree().get_nodes_in_group("player1")
	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if distance <= attack_range:
			if enemy.has_method("take_damage"):
				enemy.take_damage(attack_damage)
				print("Player 2 hit Player 1 for ", attack_damage, " damage!")

func take_damage(damage):
	if is_dead:
		return
	current_health -= damage
	print("Player 2 took ", damage, " damage. HP: ", current_health)
	if current_health <= 0:
		die()

func die():
	is_dead = true
	velocity = Vector2.ZERO
	print("Player 2 died! Player 1 wins!")
	animated_sprite.modulate = Color(0.5, 0.5, 0.5)

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "attack1":
		is_attacking = false
