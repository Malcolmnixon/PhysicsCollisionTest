extends Node3D


var _static_body : Node3D
var _character_body : CharacterBody3D
var _orientation := 0
var _collide := true
var _duration := 0.0
var _collision_point_y := 100.0
var _start_offset_y := 3.0
var _move_distance_y := 5.0


func _ready():
	# Load the static body file
	var static_scene := load(Singleton.static_body_file)
	_static_body = static_scene.instantiate()
	_static_body.scale = Vector3.ONE * Singleton.static_body_scale
	add_child(_static_body)

	# Load the static body file
	var character_scene := load(Singleton.character_body_file)
	_character_body = character_scene.instantiate()
	_character_body.scale = Vector3.ONE * Singleton.character_body_scale
	add_child(_character_body)

	# Calculate collision information
	_collision_point_y = 100.0 * Singleton.static_body_scale
	_start_offset_y = 3.0 * Singleton.character_body_scale
	_move_distance_y = 5.0 * Singleton.character_body_scale

	# Move the camera
	$Camera3D.global_position = Vector3(
		0, 
		_collision_point_y + 5.0 * Singleton.character_body_scale, 
		6.0 * Singleton.character_body_scale)
	$Camera3D.look_at(Vector3(0.0, _collision_point_y, 0.0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Skip if no bodies set
	if not _static_body or not _character_body:
		return
	
	_duration += delta

	# Construct the character rotation
	var character_rotation : Basis
	match _orientation:
		0:	# Face Y
			character_rotation = Basis.IDENTITY

		1: # Face X
			character_rotation = Basis.IDENTITY.rotated(Vector3.BACK, PI/2)

		2: # Face Z
			character_rotation = Basis.IDENTITY.rotated(Vector3.RIGHT, PI/2)

		_: # Tumbling
			character_rotation = Basis.from_euler(
				Vector3(
					_duration * 0.241352, 
					_duration * 0.328472,
					_duration * 0.442541))

	# Ensure the basis is scaled appropriately
	character_rotation = character_rotation.scaled(
		Vector3.ONE * Singleton.character_body_scale)

	# Construct the character position
	var character_position := Vector3(
			sin(_duration * 1.852451) * 2,
			_collision_point_y + _start_offset_y,
			sin(_duration * 1.622152) * 2)

	# Set the character position and rotation
	_character_body.global_transform = Transform3D(
		character_rotation,
		character_position)

	# Skip if not colliding
	if not _collide:
		return

	# Move the character down
	var collision : KinematicCollision3D = _character_body.move_and_collide(
		Vector3.DOWN * _move_distance_y)

	# Skip if no collision
	if not collision:
		return

	# Update the normal
	$Normal.global_transform = Transform3D(
		Basis.looking_at(
			collision.get_normal(), 
			Vector3.LEFT),
		collision.get_position())


func _on_done_pressed():
	get_tree().change_scene_to_file("res://main.tscn")


func _on_collide_check_box_toggled(button_pressed):
	_collide = button_pressed


func _on_orientation_option_button_item_selected(index):
	_orientation = index
