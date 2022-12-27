extends Node3D


var _static_body : StaticBody3D
var _character_body : CharacterBody3D
var _tumble := false
var _collide := true
var _duration := 0.0


func _ready():
	# Load the static body file
	var static_scene := load(Singleton.static_body_file)
	_static_body = static_scene.instantiate()
	add_child(_static_body)
	
	# Load the static body file
	var character_scene := load(Singleton.character_body_file)
	_character_body = character_scene.instantiate()
	add_child(_character_body)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Skip if no bodies set
	if not _static_body or not _character_body:
		return
	
	_duration += delta

	# Construct the character rotation
	var character_rotation := Basis.IDENTITY
	if _tumble:
		character_rotation = Basis.from_euler(
			Vector3(
				_duration * 0.241352, 
				_duration * 0.328472,
				_duration * 0.442541))

	# Construct the character position
	var character_position := Vector3(
			sin(_duration * 1.852451) * 2,
			103,
			sin(_duration * 1.622152) * 2)

	# Set the character position and rotation
	_character_body.global_transform = Transform3D(
		character_rotation,
		character_position)

	# Skip if not colliding
	if not _collide:
		return

	# Move the character down
	var collision : KinematicCollision3D = _character_body.move_and_collide(Vector3.DOWN * 4)

	# Skip if no collision
	if not collision:
		return

	# Update the normal
	$Normal.global_transform = Transform3D(
		Basis.looking_at(
			collision.get_normal(), 
			Vector3.LEFT),
		collision.get_position())


func set_bodies(static_body : StaticBody3D, character_body : CharacterBody3D):
	# Add the bodies
	add_child(static_body)
	add_child(character_body)

	# Set the bodies
	_static_body = static_body
	_character_body = character_body


func _on_done_pressed():
	get_tree().change_scene_to_file("res://main.tscn")


func _on_tumble_check_box_toggled(button_pressed):
	_tumble = button_pressed


func _on_collide_check_box_toggled(button_pressed):
	_collide = button_pressed
