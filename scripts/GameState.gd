extends Node

# Autoload singleton to track round state across scene reloads

var current_round : int = 1
var max_rounds : int = 3
var p1_round_wins : int = 0
var p2_round_wins : int = 0

func reset():
	current_round = 1
	p1_round_wins = 0
	p2_round_wins = 0
