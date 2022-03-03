extends Area2D

onready var enemy = get_tree().get_current_scene().get_node("Enemy")
func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	
var touching
onready var sprite = $Sprite

func _on_body_entered(body):
	if body.name == "Player":
		touching = true

func _on_body_exited(body):
	if body.name == "Player":
		touching = false

func _fix_color():
	var color = sprite.modulate
	if color.r > 1:
		color.r -= .3
	sprite.modulate = color

func _process(delta):
	var dfps = delta * global.fps
	if touching and get_parent().visible and get_parent().get_parent().visible:
		var r
		var f
		if get_parent().name == "wyrd":
			r = 20
			f = .05
		else:
			r = 5
			f = .1
		enemy.hp -= dfps * ((r - sprite.modulate.r) * f * 1.2) / enemy.def
		sprite.modulate.r = r 


	_fix_color()