extends InteractSimple

onready var pumpkin = get_tree().get_current_scene().get_node("CanvasLayer/PUMPKIN")
# onready var nft = get_tree().get_current_scene().get_node("Default/NFT")

onready var pumpkin_ui = pumpkin.get_node("Giant_Pumpkin_UI")


#For Loop
var btns = []

onready var congratulations = pumpkin.get_node("Congratulations")

var success : bool = false
var failed : bool = false
var correct_guess : bool = false
var correct_guess_done : bool = false
var nft_id_pumpkin : String = "GiantPumpkin"

func _ready():
	for child in pumpkin_ui.get_children():
		print(child.name)

func open_keyboard():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):
	if body.name == "Player":
		pumpkin_ui.visible = true
	
func _on_body_exited(body):
	if body.name == "Player":
		pumpkin_ui.visible = false
		nft.main.visible = false

# Here we can log the order of buttons pressed? 
var array = []
func keyboard_1_action():
	print("Play note 1 and add number 1 to array") #pass in child
func keyboard_2_action():
	print("Play note 2 and add number 2 to array")
func keyboard_3_action():
	print("Play note 3 and add number 3 to array")
func keyboard_4_action():
	print("Play note 4 and add number 4 to array")
func keyboard_5_action():
	print("Play note 5 and add number 5 to array")
func keyboard_6_action():
	print("Play note 6 and add number 6 to array")
func keyboard_7_action():
	print("Play note 7 and add number 7 to array")


# This would be the place to check if the sequence is correct?
func enter_action():
	if array == 7: #geolodge_array:
		success = true
	else:
		failed = true
		
func check_button(button):
	if button.pressed and not correct_guess:
		if not failed and not success:
			if button.name == "Note_1":
				keyboard_1_action()
			if button.name == "Note_2":
				keyboard_2_action()
			if button.name == "Note_3":
				keyboard_3_action()
			if button.name == "Note_4":
				keyboard_4_action()
			if button.name == "Note_5":
				keyboard_5_action()
			if button.name == "Note_6":
				keyboard_6_action()
			if button.name == "Note_7":
				keyboard_7_action()
		button.pressed = false
	if button.get_node("Sprite").visible:
		if array > 7:
			print("Play an error noise and reset array?")
			array.clear()

func guessed_correctly():
	nft.reward(nft_id_pumpkin)
	congratulations.get_node("Sprite").visible = true
	congratulations.get_node("Label").visible = true
	print("Change Pumpkin animation to happy")
	correct_guess_done = true
	
func _process(delta):
	if do_something:
		get_parent().creepy_city()
		do_something  = false
		open_keyboard()
		disabled = true
		nft.update(pumpkin.visible, nft_id_pumpkin)
	#	if pumpkin.visible:
	#		check_button(one_button)
		if not failed and not success and not correct_guess:
			if array.length > 7:
				 array.clear
		if failed:
			failed = false
		if success:
			success = false
			correct_guess = true
		if correct_guess and not correct_guess_done:
			# No idea about this stuff #
			guessed_correctly()
		if correct_guess_done:
			print("Wasssssup")

func _pumpkin_code(event):
	if pumpkin.visible:
		if array == 7 and array == geolodge_array():
			guessed_correctly()

		elif not correct_guess:
			if not failed and not success:
				if Input.is_action_just_pressed("Note_1"):
					keyboard_1_action()
				if Input.is_action_just_pressed("Note_2"):
					keyboard_2_action()
				if Input.is_action_just_pressed("Note_3"):
					keyboard_3_action()
				if Input.is_action_just_pressed("Note_4"):
					keyboard_4_action()
				if Input.is_action_just_pressed("Note_5"):
					keyboard_5_action()
				if Input.is_action_just_pressed("Note_6"):
					keyboard_6_action()
				if Input.is_action_just_pressed("Note_7"):
					keyboard_7_action()
