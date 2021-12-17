extends Node2D

onready var chat_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")
onready var below_player = $BehindPlayer
onready var above_player = $FrontPlayer
onready var giant_pumpkin = $GiantPumpkin

var res_path = "res://Assets/Levels/3_GeoCity/"
var request
func _ready():
	giant_pumpkin.visible = false
	var season = Global.data.season
	if season == "Winter":
		set_theme("SnowyCity")
	elif season  == "Autumn":
		set_theme("SpookyCity")
	else:
		set_theme("DefaultCity")

func set_theme(theme): #Change to Pumpkin function which is called by collision
	for child in get_node("BehindPlayer").get_children():
		if child.get_child_count() > 0:
			child.visible = true if child.name == theme else false
	for child in get_node("AbovePlayer").get_children():
		if child.get_child_count() > 0:
			child.visible = true if child.name == theme else false

	var file2Check = File.new()
	if file2Check.file_exists(res_path + theme + "/buildings.png"):
		below_player.get_node("Buildings").texture = load(res_path + theme + "/buildings.png")
	if file2Check.file_exists(res_path + theme + "/sky.png"):
		below_player.get_node("Sky").texture = load(res_path + theme + "/sky.png")

	if file2Check.file_exists(res_path + theme + "/buildings.png"):
		below_player.get_node("Buildings").texture = load(res_path + theme + "/buildings.png")
	if file2Check.file_exists(res_path + theme + "/sky.png"):
		below_player.get_node("Sky").texture = load(res_path + theme + "/sky.png")


	for child in get_node("Music").get_children():
		if child.name != theme:
			child.stop()
		else:
			child.play()

func _physics_process(delta):
	var teleport = PROGRESS.variables.get("teleport_geolodge")
	if teleport:
		chat_with.visible = false
		chat_with.stop()
		PROGRESS.variables["teleport_geolodge"] = false
		SceneChanger.change_scene("GeoLodge", 0, "WayoWayo", 1)

