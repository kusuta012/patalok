extends Node2D

var player1 = null
var player2 = null
var round_announced = false
var round_text_timer = 0.0
var round_text_display = ""
var round_over = false

func _ready():
	await get_tree().process_frame
	
	# Find Player 1
	var players = get_tree().get_nodes_in_group("player1")
	if players.size() > 0:
		player1 = players[0]
	
	# Find Player 2
	var demons = get_tree().get_nodes_in_group("player2")
	if demons.size() > 0:
		player2 = demons[0]
	
	# Show round announcement
	round_text_display = "ROUND " + str(GameState.current_round)
	round_text_timer = 2.0
	
	# Freeze players during announcement
	if player1:
		player1.set_physics_process(false)
	if player2:
		player2.set_physics_process(false)
	
	await get_tree().create_timer(2.0).timeout
	round_text_display = "FIGHT!"
	round_text_timer = 1.0
	
	await get_tree().create_timer(1.0).timeout
	round_text_display = ""
	
	# Unfreeze players
	if player1:
		player1.set_physics_process(true)
	if player2:
		player2.set_physics_process(true)

func round_end(winner: String):
	if round_over:
		return
	round_over = true
	
	if winner == "player1":
		GameState.p1_round_wins += 1
		round_text_display = "PLAYER 1 WINS ROUND " + str(GameState.current_round) + "!"
	else:
		GameState.p2_round_wins += 1
		round_text_display = "PLAYER 2 WINS ROUND " + str(GameState.current_round) + "!"
	
	round_text_timer = 3.0
	
	# Freeze both players
	if player1:
		player1.set_physics_process(false)
	if player2:
		player2.set_physics_process(false)
	
	await get_tree().create_timer(3.0).timeout
	
	if GameState.current_round >= GameState.max_rounds:
		# Match over - go to result screen
		get_tree().change_scene_to_file("res://scenes/result_screen.tscn")
	else:
		# Next round
		GameState.current_round += 1
		get_tree().reload_current_scene()

func _draw():
	# Get camera position to draw UI in screen space
	var cam_pos = Vector2.ZERO
	if get_viewport().get_camera_2d():
		cam_pos = get_viewport().get_camera_2d().get_screen_center_position() - get_viewport_rect().size / 2
	
	# Player 1 HP Bar (Top Left)
	var p1_hp_percent = 0.0
	if player1:
		p1_hp_percent = float(player1.current_health) / float(player1.max_health)
	
	draw_rect(Rect2(cam_pos + Vector2(20, 20), Vector2(200, 30)), Color.BLACK)
	draw_rect(Rect2(cam_pos + Vector2(20, 20), Vector2(200 * p1_hp_percent, 30)), Color.GREEN)
	draw_string(ThemeDB.fallback_font, cam_pos + Vector2(30, 42), "P1: " + str(player1.current_health if player1 else 0) + "/100", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color.WHITE)
	
	# Player 2 HP Bar (Top Right)
	var p2_hp_percent = 0.0
	if player2:
		p2_hp_percent = float(player2.current_health) / float(player2.max_health)
	
	var screen_width = get_viewport_rect().size.x
	draw_rect(Rect2(cam_pos + Vector2(screen_width - 220, 20), Vector2(200, 30)), Color.BLACK)
	draw_rect(Rect2(cam_pos + Vector2(screen_width - 220, 20), Vector2(200 * p2_hp_percent, 30)), Color.RED)
	draw_string(ThemeDB.fallback_font, cam_pos + Vector2(screen_width - 210, 42), "P2: " + str(player2.current_health if player2 else 0) + "/100", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color.WHITE)
	
	# Round indicator (top center)
	var round_info = "Round " + str(GameState.current_round) + "/" + str(GameState.max_rounds) + "   P1: " + str(GameState.p1_round_wins) + " - " + str(GameState.p2_round_wins) + " :P2"
	draw_string(ThemeDB.fallback_font, cam_pos + Vector2(screen_width / 2 - 120, 42), round_info, HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color.WHITE)
	
	# Big center text (round announcements, fight, round winner)
	if round_text_display != "":
		draw_string(ThemeDB.fallback_font, cam_pos + Vector2(screen_width / 2 - 150, 300), round_text_display, HORIZONTAL_ALIGNMENT_LEFT, -1, 48, Color(1, 0.85, 0.2))

func _process(_delta):
	queue_redraw()
