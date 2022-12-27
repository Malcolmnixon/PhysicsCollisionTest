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

const CHARACTER_FILES := [
	"res://objects/dynamic/dynamic_sphere.tscn",
	"res://objects/dynamic/dynamic_capsule.tscn",
	"res://objects/dynamic/dynamic_cylinder.tscn",
	"res://objects/dynamic/dynamic_box.tscn",
	"res://objects/dynamic/dynamic_convex.tscn",
	"res://objects/dynamic/dynamic_concave.tscn"
]



func _on_button_pressed():
	# Select the objects
	Singleton.static_body_file = STATIC_FILES[%StaticOptions.selected]
	Singleton.character_body_file = CHARACTER_FILES[%CharacterOptions.selected]

	# Switch to the collision test scene
	get_tree().change_scene_to_file("res://collision_test.tscn")
