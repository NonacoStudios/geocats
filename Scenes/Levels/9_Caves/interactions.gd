extends InteractButton


func _input(event):
	if _can_interact():
		object.visible = false
		if name == "GoToLodge":
			SceneChanger.change_scene("GeoLodge", 2, "WoodDoorLatchOpen1", 1.5)