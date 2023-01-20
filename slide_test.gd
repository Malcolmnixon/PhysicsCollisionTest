extends Node3D


var _static_body : Node3D
var _character_body : CharacterBody3D
var _debug_material : StandardMaterial3D
var _debug_mesh : ImmediateMesh
var _orientation := 0
var _duration := 0.0
var _collision_point_y := 100.0
var _start_offset_y := 3.0
var _move_distance_y := 8.0
var _path_position : Vector3


# Called when the node enters the scene tree for the first time.
func _ready():
	# Construct the debug material
	_debug_material = StandardMaterial3D.new()
	_debug_material.no_depth_test = true
	_debug_material.cull_mode = BaseMaterial3D.CULL_DISABLED
	_debug_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED

	# Get the debug mesh
	_debug_mesh = $CollisionDebug.mesh

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

	# Construct the direction vector
	var direction := Vector3(
			sin(_duration * 0.321521),
			-1.0,
			cos(_duration * 0.245155)).normalized()

	# Move and slide the character down
	_character_body.velocity = direction * _move_distance_y / delta

	# Render the path
	_debug_mesh.clear_surfaces()
	_start_path_draw(character_position)

	# Draw the collide
	var collided := _character_body.move_and_slide()
	if collided:
		for i in _character_body.get_slide_collision_count():
			var collosion := _character_body.get_slide_collision(i)
			_add_path_draw(
					collosion.get_position(),
					collosion.get_normal())
	
	_end_path_draw(_character_body.global_position)


func _start_path_draw(position : Vector3):
	_debug_mesh.surface_begin(Mesh.PRIMITIVE_LINES, _debug_material)
	_path_position = position

func _add_path_draw(position : Vector3, normal : Vector3):
	# Draw path
	_debug_mesh.surface_add_vertex(_path_position)
	_debug_mesh.surface_add_vertex(position)

	# Draw normal
	_debug_mesh.surface_add_vertex(position)
	_debug_mesh.surface_add_vertex(position + normal)
	_path_position = position

func _end_path_draw(position : Vector3):
	# Draw path
	_debug_mesh.surface_add_vertex(_path_position)
	_debug_mesh.surface_add_vertex(position)
	_debug_mesh.surface_end()

func _on_done_pressed():
	get_tree().change_scene_to_file("res://main.tscn")


func _on_orientation_option_button_item_selected(index):
	_orientation = index
