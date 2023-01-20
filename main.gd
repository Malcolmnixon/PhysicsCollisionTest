extends Control


## Table of static body files
const STATIC_FILES := [
	"res://objects/static/static_sphere.tscn",
	"res://objects/static/static_capsule.tscn",
	"res://objects/static/static_cylinder.tscn",
	"res://objects/static/static_box.tscn",
	"res://objects/static/static_convex.tscn",
	"res://objects/static/static_concave.tscn",
	"res://objects/static/static_boundary.tscn"
]

## Table of character body files
const CHARACTER_FILES := [
	"res://objects/dynamic/dynamic_sphere.tscn",
	"res://objects/dynamic/dynamic_capsule.tscn",
	"res://objects/dynamic/dynamic_cylinder.tscn",
	"res://objects/dynamic/dynamic_box.tscn",
	"res://objects/dynamic/dynamic_convex.tscn",
	"res://objects/dynamic/dynamic_concave.tscn"
]

## Table of scales
const SCALES := [ 0.5, 1.0, 2.0, 4.0 ]



func _on_button_pressed():
	# Select the objects and scales
	Singleton.static_body_file = STATIC_FILES[%StaticOptions.selected]
	Singleton.static_body_scale = SCALES[%StaticScale.selected]
	Singleton.character_body_file = CHARACTER_FILES[%CharacterOptions.selected]
	Singleton.character_body_scale = SCALES[%CharacterScale.selected]

	# Switch to the collision test scene
	get_tree().change_scene_to_file("res://collision_test.tscn")
