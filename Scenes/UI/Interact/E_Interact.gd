extends AreaInteract
class_name E_Interact, "res://Assets/UI/Debug/soundeffect_icon.png"

onready var current_scene = get_tree().get_current_scene()
onready var player = get_tree().get_current_scene().player
onready var dialogue = get_tree().get_current_scene().get_node("Default/CanvasLayer/Dialogue")
onready var feline = get_tree().get_current_scene().get_node("Default/CanvasLayer/Feline")
export(String, FILE, "*.json") var dialogue_file = ""
export(String, FILE, "*.wav, *.ogg") var sound_effect
export(float) var sound_volume = 1

var do_something 
var playing = false
var button
var disable_sound = false
var hide_when_playing = true
var dia_started
export var require_grounded = false
export var disable_player = ""
export var button_reappear_delay = 0.5
func _ready():
	._ready()
	var e_button = preload("res://Scenes/UI/Interact/E_Interact.tscn").instance()

	add_child(e_button)
	button = e_button.get_node("Control")
	button.modulate.a = 0
	
func _is_grounded():
	return true if require_grounded and player.is_on_floor() or not require_grounded else false
		
func _is_disabled():
	var state = current_scene.is_disabled("e_interact")
	state = not state and _is_grounded() and button and not (playing and hide_when_playing) and not disabled
	state = not state
	return state
var timer = -1
func _process(delta):
	if name == "ShowInstructionManual":
		print(name ,_is_disabled())
	if timer >= 0:
		timer += delta
		disabled = true
		if timer >= button_reappear_delay:
			timer = -1
			disabled = false
	if touching and not _is_disabled():
		if button.modulate.a == 0:
			utils.tween_fade(button, 0, 1, 0.2)
				
	elif button.modulate.a == 1:
		utils.tween_fade(button, 1, 0, 0.2)
		
	if do_something:
		if not dialogue_file.empty():
			disabled = true
			dialogue.initiate(dialogue_file)
			dialogue.modulate.a = 0.01
			dia_started = true
		do_something = false
	if dia_started and dialogue.modulate.a == 0:
		dia_started = false
		disabled = false
	if not touching and dia_started:
		dialogue.exit()
func _input(_event):
	# when i press the interact key (e)
	if Input.is_action_just_pressed("interact") and not _is_disabled() and button.modulate.a > 0:
		if touching and dialogue.modulate.a == 0:
			do_something = true
			if not disable_player.empty():
				current_scene.set_disable("player", disable_player)
			if sound_effect and (not playing or not hide_when_playing) and not disable_sound:
				AudioManager.play_sound(sound_effect, sound_volume, false, self, player)
				playing = true
			
