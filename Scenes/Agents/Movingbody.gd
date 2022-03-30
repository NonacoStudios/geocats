extends KinematicBody2D
class_name MovingBody


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") setget ,_get_gravity

func _get_gravity():
	return ProjectSettings.get_setting("physics/2d/default_gravity")

onready var sprite = $AnimatedSprite

export(bool) var add_move_n_slide = false

# variables for all entities
var no_rotate = false
var no_gravity = false
export(bool) var mirror_sprite = false
var velocity : Vector2 = Vector2.ZERO
# one way collding platform
var current_platforms = {}
var disabled_platforms = {}
# fall through platform
var fall_through_timer
# jump height
export var jump_height = 100

func fall_through(layer_bit = 0):

	for platform in current_platforms.keys():
		platform.set_collision_layer_bit(layer_bit, false)
		disabled_platforms[platform] = layer_bit
	fall_through_timer.start()

func check_child_collision(child):
	if (child is CollisionShape2D || child is CollisionPolygon2D) && child.is_one_way_collision_enabled():
		return true
	else:
		return false


func apply_gravity (factor: float = 1):
	velocity.y += gravity * factor

# ladder variables
var on_ladder : bool = false
var ladder_x : float
var ladder_y : float
var ladder_rot : float
var ladder_tween : Tween
var max_angle = 0.7
# tween to ladder function
func tween_to_ladder():
	var new_x = ladder_x
	if ladder_rot != 0:
		var diff_y = position.y / ladder_y
		new_x = ladder_x - 25 *  (diff_y - 1) * ladder_rot

	var target = Vector2(new_x, position.y)
	
	# warning-ignore:return_value_discarded
	ladder_tween.interpolate_property(self, "position", position, target, 0.05, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	# warning-ignore:return_value_discarded
	ladder_tween.start()

func _ready():
	# add ladder tween
	ladder_tween = Tween.new()
	add_child(ladder_tween)
	randomize()
	fall_through_timer = Timer.new()
	add_child(fall_through_timer)
	fall_through_timer.wait_time = 0.2
	fall_through_timer.one_shot = true

	
func _stop_playing(stream):
	remove_child(stream)

	
func jump(jumpHeight):
	velocity.y = 0 #reset velocity
	velocity.y = -sqrt(50 * gravity * jumpHeight) 
	
var new_rot : float
var mushroom
func _physics_process(_delta):
	if mushroom and mushroom.touching:
		mushroom.touching = false

	var rot = sprite.rotation
	if fall_through_timer.time_left == 0:
		for platform in disabled_platforms:
			var layer_bit = disabled_platforms[platform]

			platform.set_collision_layer_bit(layer_bit, true)
		disabled_platforms = {}
	current_platforms = {}
	var slide_count = get_slide_count()

	if slide_count > 0:
		new_rot = 0
		for i in slide_count:
			var collision = get_slide_collision(i)
			if is_on_floor():
				for child in collision.collider.get_children():
					if check_child_collision(child):
						current_platforms[child.get_parent()] = true
					if child.get_parent().is_in_group("mushroom"):
						mushroom = child.get_parent()
						mushroom.touching = true
						jump(jump_height * mushroom.jump_multiplier)

			var normal = collision.normal

			if normal.x > -max_angle && normal.x < max_angle and normal.y < max_angle:
				var slope_angle = normal.dot(Vector2(0,-1)) - 1
				new_rot += -slope_angle * 3 * normal.x
			else:
				new_rot = rot * .5
	else:
		slide_count = 1
		new_rot = rot * .5

	if rot != new_rot:
		rot = (new_rot / slide_count + rot * 3) / 4
	if not no_rotate:
		sprite.rotation = rot
	if sprite.animation != "climb" and not no_gravity:
		apply_gravity()
	if add_move_n_slide:
		velocity = move_and_slide(velocity, Vector2.UP, true) #apply velocity to movement




