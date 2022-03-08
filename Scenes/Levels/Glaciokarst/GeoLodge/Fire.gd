extends E_Interact

onready var sprite = $AnimatedSprite

func _add_fire():
	sprite.visible = true
	#AudioManager.play_sound("SFX",name)
	disabled = true

func _ready():
	if PROGRESS.variables.has("fire"):
		_add_fire()

func _process(delta):
	._process(delta)
	if do_something:
		do_something = false
		_add_fire()
		PROGRESS.variables["fire"] = true
