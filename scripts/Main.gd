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
	
	var screen_width = get_viewport_rect().size.x
	var bar_width = 220.0
	var bar_height = 22.0
	var bar_y = 18.0
	var border_color = Color(0.9, 0.8, 0.5, 0.8)
	
	# ---- Player 1 HP Bar (Top Left) ----
	var p1_hp_percent = 0.0
	if player1:
		p1_hp_percent = clamp(float(player1.current_health) / float(player1.max_health), 0.0, 1.0)
	
	# Name label
	draw_string(ThemeDB.fallback_font, cam_pos + Vector2(20, bar_y - 2), "PRINCE", HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color(0.8, 0.9, 0.8, 0.9))
	
	# Bar background
	draw_rect(Rect2(cam_pos + Vector2(20, bar_y + 12), Vector2(bar_width, bar_height)), Color(0.15, 0.15, 0.15, 0.9))
	# HP fill - green to yellow to red based on health
	var p1_color = Color(0.2, 0.9, 0.3) if p1_hp_percent > 0.5 else (Color(1.0, 0.8, 0.1) if p1_hp_percent > 0.25 else Color(0.9, 0.15, 0.1))
	draw_rect(Rect2(cam_pos + Vector2(20, bar_y + 12), Vector2(bar_width * p1_hp_percent, bar_height)), p1_color)
	# Bar border
	draw_rect(Rect2(cam_pos + Vector2(20, bar_y + 12), Vector2(bar_width, bar_height)), border_color, false, 2.0)
	# HP text
	var p1_hp_text = str(player1.current_health if player1 else 0) + " / 100"
	draw_string(ThemeDB.fallback_font, cam_pos + Vector2(bar_width / 2 - 10, bar_y + 28), p1_hp_text, HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color.WHITE)
	
	# ---- Player 2 HP Bar (Top Right) ----
	var p2_hp_percent = 0.0
	if player2:
		p2_hp_percent = clamp(float(player2.current_health) / float(player2.max_health), 0.0, 1.0)
	
	var p2_bar_x = screen_width - bar_width - 20
	
	# Name label
	draw_string(ThemeDB.fallback_font, cam_pos + Vector2(p2_bar_x, bar_y - 2), "NARAKASUR", HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color(0.9, 0.7, 0.7, 0.9))
	
	# Bar background
	draw_rect(Rect2(cam_pos + Vector2(p2_bar_x, bar_y + 12), Vector2(bar_width, bar_height)), Color(0.15, 0.15, 0.15, 0.9))
	# HP fill (right-aligned: bar fills from right to left)
	var p2_color = Color(0.9, 0.2, 0.2) if p2_hp_percent > 0.5 else (Color(1.0, 0.8, 0.1) if p2_hp_percent > 0.25 else Color(0.9, 0.15, 0.1))
	var p2_fill_width = bar_width * p2_hp_percent
	draw_rect(Rect2(cam_pos + Vector2(p2_bar_x + bar_width - p2_fill_width, bar_y + 12), Vector2(p2_fill_width, bar_height)), p2_color)
	# Bar border
	draw_rect(Rect2(cam_pos + Vector2(p2_bar_x, bar_y + 12), Vector2(bar_width, bar_height)), border_color, false, 2.0)
	# HP text
	var p2_hp_text = str(player2.current_health if player2 else 0) + " / 100"
	draw_string(ThemeDB.fallback_font, cam_pos + Vector2(p2_bar_x + bar_width / 2 - 15, bar_y + 28), p2_hp_text, HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color.WHITE)
	
	# ---- Round Banner (top center) ----
	var banner_w = 260.0
	var banner_h = 44.0
	var banner_x = screen_width / 2 - banner_w / 2
	var banner_y = 8.0
	
	# Banner background
	draw_rect(Rect2(cam_pos + Vector2(banner_x, banner_y), Vector2(banner_w, banner_h)), Color(0.08, 0.06, 0.12, 0.85))
	draw_rect(Rect2(cam_pos + Vector2(banner_x, banner_y), Vector2(banner_w, banner_h)), Color(1, 0.78, 0.15, 0.6), false, 1.5)
	
	# Round text
	var round_text = "ROUND " + str(GameState.current_round) + " / " + str(GameState.max_rounds)
	draw_string(ThemeDB.fallback_font, cam_pos + Vector2(banner_x + banner_w / 2 - 55, banner_y + 18), round_text, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color(1, 0.85, 0.3))
	
	# Score text
	var score_text = str(GameState.p1_round_wins) + "  -  " + str(GameState.p2_round_wins)
	draw_string(ThemeDB.fallback_font, cam_pos + Vector2(banner_x + banner_w / 2 - 20, banner_y + 37), score_text, HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color(0.8, 0.8, 0.8, 0.9))
	
	# ---- Big center text (round announcements) ----
	if round_text_display != "":
		# Dark backdrop for readability
		var text_bg_w = 500.0
		var text_bg_h = 80.0
		draw_rect(Rect2(cam_pos + Vector2(screen_width / 2 - text_bg_w / 2, 260), Vector2(text_bg_w, text_bg_h)), Color(0, 0, 0, 0.6))
		draw_rect(Rect2(cam_pos + Vector2(screen_width / 2 - text_bg_w / 2, 260), Vector2(text_bg_w, text_bg_h)), Color(1, 0.78, 0.15, 0.4), false, 2.0)
		draw_string(ThemeDB.fallback_font, cam_pos + Vector2(screen_width / 2 - 150, 310), round_text_display, HORIZONTAL_ALIGNMENT_LEFT, -1, 48, Color(1, 0.85, 0.2))

func _process(_delta):
	queue_redraw()
