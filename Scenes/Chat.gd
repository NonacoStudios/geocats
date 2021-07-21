extends Area2D

onready var player =  get_tree().get_current_scene().get_node("Player")
onready var chat_with = get_tree().get_current_scene().get_node("CanvasLayer/ChatWith")

var active : bool

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")


func show_chat():
	active = true
	chat_with.visible = true
	chat_with.name_label.text = get_parent().name
	
func hide_chat():
	chat_with.visible = false
	chat_with.stop()
	active = false

func _on_body_entered(body):
	if body.name == "Player":
		show_chat()

func _on_body_exited(body):
	if body.name == "Player":
		hide_chat()

func _process(delta):
	if active and "idle" in get_parent():
		if chat_with.started:
			get_parent().idle = true
		else:
			get_parent().idle = false

func _input(event):
	if active:
		if Input.is_action_just_pressed("interact"):
			print(get_parent())
			chat_with.start(get_parent().name)