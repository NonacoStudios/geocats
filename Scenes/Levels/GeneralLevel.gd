extends Node2D
class_name GeneralLevel

export(NodePath) var player

export(Array, Vector2) onready var locations 
func get_player():
	if not player:
		player = get_node_or_null(player)
		if not player:
			player = get_node_or_null("Default/Player")
			if not player:
				player = get_node_or_null("Player")
				if not player:
					printerr("can't find player node: ", player)
	return player

func _ready():
	# find player node
	player = get_player()
	if not player:
		player = get_node_or_null("Default/Player")
		if not player:
			player = get_node_or_null("Player")
			if not player:
				printerr("can't find player node: ", player)

	# set player location
	if locations:
		locations[0] = player.position

		player.position = locations[global.user.location]

