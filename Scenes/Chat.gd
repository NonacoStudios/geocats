extends Area2D

onready var player =  get_tree().get_current_scene().get_node("Default/Player")
onready var chat_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")

var active : bool
var disabled : bool
var parent_name : String
var convo_file : String
func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _get_complex_convo():
	var scene_name = get_tree().get_current_scene().name
	return parent_name + "_" + scene_name

func show_chat():
	parent_name = get_parent().name
	if parent_name == "Affogato":
		convo_file = _get_complex_convo()
	else:
		convo_file = parent_name.replace(" ", "_")
	active = true
	chat_with.hide_after = false
	chat_with.visible = true
	chat_with.name_label.text = parent_name
	
func hide_chat():
	chat_with.visible = false
	chat_with.stop()
	active = false

func _on_body_entered(body):
	if body.name == "Player" and not disabled:
		show_chat()

func _on_body_exited(body):
	if body.name == "Player":
		hide_chat()

func _process(delta):
	if disabled and active:
		hide_chat()
	if active and "idle" in get_parent():
		if chat_with.started:
			get_parent().idle = true
		else:
			get_parent().idle = false

func _input(event):
	if active:
		if Input.is_action_just_pressed("interact"):
			chat_with.start(convo_file)
